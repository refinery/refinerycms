class Inquiry < ActiveRecord::Base

  validates_presence_of :name, :message
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  acts_as_indexed :fields => [:name, :email, :message, :phone]

  named_scope :newest, :order => 'created_at DESC'

  named_scope :ham, lambda {{:conditions => {:spam => false}, :order => 'created_at DESC'}}
  named_scope :spam, lambda {{:conditions => {:spam => true}, :order => 'created_at DESC'}}

  before_validation_on_create :calculate_spam_score

  cattr_accessor :spam_words
  self.spam_words = %w{
    -online 4u 4-u acne adipex advicer baccarrat blackjack bllogspot booker buy byob carisoprodol
    casino chatroom cialis coolhu credit-card-debt cwas cyclen cyclobenzaprine
    day-trading debt-consolidation discreetordering duty-free dutyfree equityloans fioricet
    freenet free\s*shipping gambling- hair-loss homefinance holdem incest jrcreations leethal levitra macinstruct
    mortgagequotes nemogs online-gambling ottawavalleyag ownsthis paxil penis pharmacy phentermine
    poker poze pussy ringtones roulette shemale shoes -site slot-machine thorcarlson
    tramadol trim-spa ultram valeofglamorganconservatives viagra vioxx xanax zolus
  }

  def self.latest(number = 7, include_spam = false)
    unless include_spam
      ham.find(:all, :limit => number)
    else
      newest.find(:all, :limit => number)
    end
  end

  def ham?
    not spam?
  end

  def ham!
    self.update_attribute(:spam, false)
  end

  def spam!
    self.update_attribute(:spam, true)
  end

protected

  # heavily based off http://github.com/rsl/acts_as_snook
  # which is based off http://snook.ca/archives/other/effective_blog_comment_spam_blocker

  def score_for_body_links
    link_count = self.message.to_s.scan(/http:/).size
    link_count > 2 ? -link_count : 2
  end

  def score_for_body_length
    if self.message.to_s.length > 20 and self.message.to_s.scan(/http:/).size.zero?
      2
    else
      -1
    end
  end

  def score_for_previous_inquiries
    current_score = 0

    Inquiry.find(:all, :conditions => {:email => email}).each do |i|
      if i.spam?
        current_score -= 1
      else
        current_score += 1
      end
    end

    current_score
  end

  def score_for_spam_words
    current_score = 0

    spam_words.each do |word|
      regex = /#{word}/i
      current_score -= 1 if message =~ regex || name =~ regex || phone =~ regex
    end

    current_score
  end

  def score_for_suspect_url
    current_score = 0

    regex = /http:\/\/\S*(\.html|\.info|\?|&|free)/i
    current_score =- (1 * message.to_s.scan(regex).size)
  end

  def score_for_suspect_tld
    regex = /http:\/\/\S*\.(de|pl|cn)/i
    message.to_s.scan(regex).size * -1
  end

  def score_for_lame_body_start
    message.to_s.strip =~ /^(interesting|sorry|nice|cool)/i ? -10 : 0
  end

  def score_for_author_link
    name.to_s.scan(/http:/).size * -2
  end

  def score_for_same_body
    Inquiry.count(:conditions => {:message => message}) * -1
  end

  def score_for_consonant_runs
    current_score = 0

    [name, message, phone, email].each do |field|
      field.to_s.scan(/[bcdfghjklmnpqrstvwxz]{5,}/).each do |run|
        current_score =- run.size - 4
      end
    end

    current_score
  end

  def calculate_spam_score
    score = 0
    score += score_for_body_links
    score += score_for_body_length
    score += score_for_previous_inquiries
    score += score_for_spam_words
    score += score_for_suspect_tld
    score += score_for_lame_body_start
    score += score_for_author_link
    score += score_for_same_body
    score += score_for_consonant_runs
    self.spam = (score < 0)

    logger.info("spam score was #{score}")

    true
  end

end

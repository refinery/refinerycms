class NewsItem < ActiveRecord::Base

  validates_presence_of :title, :body, :publish_date

  has_friendly_id :title, :use_slug => true

  acts_as_indexed :fields => [:title, :body],
                  :index_file => %W(#{Rails.root} tmp index)

  default_scope :order => "publish_date DESC"
  # If you're using a named scope that includes a changing variable you need to wrap it in a lambda
  # This avoids the query being cached thus becoming unaffected by changes (i.e. Time.now is constant)
  named_scope :latest, lambda { { :conditions => ["publish_date < ?", Time.now], :limit => 10 } }
  named_scope :published, lambda { { :conditions => ["publish_date < ?", Time.now] } }

  def not_published? # has the published date not yet arrived?
    publish_date > Time.now
  end

  def self.per_page
    20
  end

end

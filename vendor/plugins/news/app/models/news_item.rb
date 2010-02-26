class NewsItem < ActiveRecord::Base

  validates_presence_of :title, :body, :publish_date

  has_friendly_id :title, :use_slug => true

  acts_as_indexed :fields => [:title, :body],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  default_scope :order => "publish_date DESC"
  named_scope :latest, :conditions => ["publish_date < ?", Time.now], :limit => 10
  named_scope :published, :conditions => ["publish_date < ?", Time.now]

  def not_published? # has the published date not yet arrived?
    publish_date > Time.now
  end

  def self.per_page
    20
  end

end

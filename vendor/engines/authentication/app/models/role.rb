class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  before_validation :camelize_title
  validates_uniqueness_of :title

  def camelize_title
    self.title = title.camelize
  end

  def self.[](title)
    find_or_create_by_title(title.to_s)
  end

end

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  before_validation :camelize_title
  validates_uniqueness_of :title

  def camelize_title
    self.title = title.camelize
  end

end

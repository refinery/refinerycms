class Layout < ActiveRecord::Base
  acts_as_indexed :fields => [:template_name]

  validates :template_name, :presence => true, :uniqueness => true
end

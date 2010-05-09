class Inquiry < ActiveRecord::Base

  validates_presence_of :name
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => 'must be valid'

  acts_as_indexed :fields => [:name, :email, :message, :phone],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  default_scope :order => 'created_at DESC'

end

class Inquiry < ActiveRecord::Base

  validates_presence_of :name
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => 'must be valid'

  acts_as_indexed :fields => [:name, :email, :message, :phone],
          :index_file => [RAILS_ROOT,"tmp","index"]

  def self.closed
    find_all_by_open(false, :order => "created_at DESC")
  end

  def self.opened
    find_all_by_open(true, :order => "created_at DESC")
  end

end

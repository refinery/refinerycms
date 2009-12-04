class Company < ActiveRecord::Base

  belongs_to :owner, :foreign_key => 'owner_id', :class_name => 'User'
  belongs_to :country
  
  has_one :address, :as => :addressable
  
  has_many :users
  
  has_and_belongs_to_many :freelancers
end
class User < ActiveRecord::Base
  
  has_one :company, :foreign_key => 'owner_id'
  has_one :address, :as => :addressable 

  has_and_belongs_to_many :users, :join_table => "purchases", :association_foreign_key => 'present_id', :foreign_key => 'buyer_id'
  
  validates_uniqueness_of :name
  
  def search_via_email(email = "user@domain.com")
    self.find_by_email(email)
  end
  
  def search_via_email_and_name(email, name)
    self.find_by_email_and_name(email, name)
  end
end
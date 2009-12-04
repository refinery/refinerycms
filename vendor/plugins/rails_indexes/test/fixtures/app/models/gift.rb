class Gift < ActiveRecord::Base
  
  set_primary_key :custom_primary_key
  has_and_belongs_to_many :users, :join_table => "purchases", :association_foreign_key => 'buyer_id', :foreign_key => 'present_id'
  
  def search_all(name, price)
    Gift.find_all_by_name_and_price(name, price)
  end
  
end
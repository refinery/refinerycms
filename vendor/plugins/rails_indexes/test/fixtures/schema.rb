ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.column "name",  :text
    t.column "email", :text
  end
  
  create_table "companies", :force => true do |t|
    t.column "name",  :text
    t.column "owned_id", :integer
    t.column "country_id", :integer
  end
  
  add_index :companies, :country_id
  
  create_table "addresses", :force => true do |t|
    t.column "addressable_type", :string
    t.column "addressable_id", :integer
    t.column "address", :text
    t.column "country_id", :integer
  end
  
  create_table "freelancers", :force => true do |t|
    t.column "name", :string
    t.column "price_per_hour", :integer
  end
  
  create_table "companies_freelancers", :force => true do |t|
    t.column "freelancer_id", :integer
    t.column "company_id", :integer
  end
  
  create_table "gifts", :force => true do |t|
    t.column "custom_primary_key", :integer
    t.column "name", :string
    t.column "price", :integer
  end
  
  create_table "purchases", :force => true do |t|
    t.column "present_id", :integer
    t.column "buyer_id", :integer
  end
  
  create_table "countries", :force => true do |t|
    t.column "name", :string
  end
end
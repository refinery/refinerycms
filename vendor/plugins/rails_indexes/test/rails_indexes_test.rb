require 'test_helper'

class RailsIndexesTest < ActiveSupport::TestCase
  
  test "relationship indexes are found" do
    @relationship_indexes = Indexer.check_for_indexes

    assert @relationship_indexes.size > 0
    
    assert @relationship_indexes.has_key?("companies")
    assert @relationship_indexes.has_key?("companies_freelancers")
    assert @relationship_indexes.has_key?("addresses")
    assert @relationship_indexes.has_key?("purchases")
  end
  
  # should add 2 composite indexes or each pair
  test "has_and_belongs_to_many" do
    @relationship_indexes = Indexer.check_for_indexes(true)
    
    assert @relationship_indexes["companies_freelancers"].include?(["company_id", "freelancer_id"])
    assert @relationship_indexes["companies_freelancers"].include?(["freelancer_id", "company_id"])
  end
  
  test "has_and_belongs_to_many with custom columns" do
    @relationship_indexes = Indexer.check_for_indexes(true)
    
    assert @relationship_indexes["purchases"].include?(["present_id", "buyer_id"])
    assert @relationship_indexes["purchases"].include?(["buyer_id", "present_id"])
  end
  
  test "belongs_to" do
    @relationship_indexes = Indexer.check_for_indexes(true)
    assert @relationship_indexes["addresses"].include?("country_id")
  end
  
  test "belongs_to with a custom foreign key" do
    @relationship_indexes = Indexer.check_for_indexes(true)
    assert @relationship_indexes["companies"].include?("owner_id")
  end
  
  test "should not add an already existing index" do
    @relationship_indexes = Indexer.check_for_indexes(true)
    assert !(@relationship_indexes["companies"].include?("country_id"))
  end
  
  test "default find_by indexes for primary keys" do
    @find_by_indexes = Indexer.ar_find_indexes(false)
    
    # Default added the primary key for each table
    assert @find_by_indexes.has_key?("users")
    assert @find_by_indexes.has_key?("companies")
    assert @find_by_indexes.has_key?("gifts")
    assert @find_by_indexes.has_key?("freelancers")
    assert @find_by_indexes.has_key?("countries")
  end
  
  test "default find_by indexes for custom primary keys" do
    @find_by_indexes = Indexer.ar_find_indexes(false)

    assert @find_by_indexes["gifts"].include?("custom_primary_key")
  end
  
  test "find_by indexes for self.find_by_email_and_name" do
    @find_by_indexes = Indexer.ar_find_indexes(false)
    
    assert @find_by_indexes["users"].include?(["name", "email"])
    assert @find_by_indexes["users"].include?(["email", "name"])
  end
  
  test "find_by indexes for Gift.find_all_by_name_and_price" do
    @find_by_indexes = Indexer.ar_find_indexes(false)
    
    assert @find_by_indexes["gifts"].include?(["name", "price"])
    assert @find_by_indexes["gifts"].include?(["price", "name"])
  end
  
  test "find_by indexes from UsersController" do
    @find_by_indexes = Indexer.ar_find_indexes(false)
    
    assert @find_by_indexes["freelancers"].include?("name")

  end
end

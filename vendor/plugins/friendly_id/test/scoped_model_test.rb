require File.dirname(__FILE__) + '/test_helper'

class ScopedModelTest < Test::Unit::TestCase
  context "A slugged model that uses a scope" do
    setup do
      Person.delete_all
      Country.delete_all
      Slug.delete_all

      @usa = Country.create!(:name => "USA")
      @canada = Country.create!(:name => "Canada")

      @person1 = Person.create!(:name => "John Smith", :country => @usa)
      @person2 = Person.create!(:name => "John Smith", :country => @canada)
    end

    should 'generate the same friendly ids for records in different scopes' do
      assert_equal @person1.friendly_id, @person2.friendly_id
    end

    should 'generate unique friendly ids for records in the same scope' do
      person3 = Person.create!(:name => 'John Smith', :country => @usa)

      assert_not_equal person3.friendly_id, @person1.friendly_id
    end

    should "find all scoped records without scope" do
      assert_equal 2, Person.find(:all, @person1.friendly_id).size
    end

    should "find a single scoped records with a scope" do
      assert_equal @person1, @usa.people.find(@person1.friendly_id)
      assert_equal @person2, @canada.people.find(@person2.friendly_id)
    end

    should 'find a single scoped record without scope if it is unique' do
      person3 = Person.create!(:name => 'John Doe', :country => @usa)

      assert_equal person3, Person.find(person3.friendly_id)
    end
  end
end

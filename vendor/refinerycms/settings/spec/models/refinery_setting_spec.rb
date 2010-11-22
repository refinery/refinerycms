require 'spec_helper'

describe RefinerySetting do

  before(:each) do
    RefinerySetting.set(:creating_from_scratch, nil)
    RefinerySetting.set(:rspec_testing_creating_from_scratch, nil)
  end

  context "set" do
    it "should create a setting that didn't exist" do
      RefinerySetting.get(:creating_from_scratch, :scoping => 'rspec_testing').should == nil
      RefinerySetting.set(:creating_from_scratch, {:value => "Look, a value", :scoping => 'rspec_testing'}).should == "Look, a value"
    end

    it "should override an existing setting" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "a value", :scoping => 'rspec_testing'})
      @set.should == "a value"

      @new_set = RefinerySetting.set(:creating_from_scratch, {:value => "newer replaced value", :scoping => 'rspec_testing'})
      @new_set.should == "newer replaced value"
    end

    it "should default to form_value_type text_area" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "a value", :scoping => 'rspec_testing'})
      RefinerySetting.find_by_name(:creating_from_scratch.to_s, :conditions => {:scoping => 'rspec_testing'}).form_value_type.should == "text_area"
    end

    it "should fix true as a value to 'true' (string)" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => true, :scoping => 'rspec_testing'})
      RefinerySetting.find_by_name(:creating_from_scratch.to_s, :conditions => {:scoping => 'rspec_testing'})[:value].should == 'true'
      @set.should == true
    end

    it "should fix false as a value to 'false' (string)" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => false, :scoping => 'rspec_testing'})
      RefinerySetting.find_by_name(:creating_from_scratch.to_s, :conditions => {:scoping => 'rspec_testing'})[:value].should == 'false'
      @set.should == false
    end

    it "should fix '1' as a value with a check_box form_value_type to true" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "1", :scoping => 'rspec_testing', :form_value_type => 'check_box'})
      RefinerySetting.find_by_name(:creating_from_scratch.to_s, :conditions => {:scoping => 'rspec_testing'})[:value].should == 'true'
      @set.should == true
    end

    it "should fix '0' as a value with a check_box form_value_type to false" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "0", :scoping => 'rspec_testing', :form_value_type => 'check_box'})
      RefinerySetting.find_by_name(:creating_from_scratch.to_s, :conditions => {:scoping => 'rspec_testing'})[:value].should == 'false'
      @set.should == false
    end
  end

  context "get" do
    it "should retrieve a seting that was created" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "some value", :scoping => 'rspec_testing'})
      @set.should == 'some value'

      @get = RefinerySetting.get(:creating_from_scratch, :scoping => 'rspec_testing')
      @get.should == 'some value'
    end

    it "should also work with setting scoping using string and getting via symbol" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "some value", :scoping => 'rspec_testing'})
      @set.should == 'some value'

      @get = RefinerySetting.get(:creating_from_scratch, :scoping => :rspec_testing)
      @get.should == 'some value'
    end

    it "should also work with setting scoping using symbol and getting via string" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "some value", :scoping => :rspec_testing})
      @set.should == 'some value'

      @get = RefinerySetting.get(:creating_from_scratch, :scoping => 'rspec_testing')
      @get.should == 'some value'
    end
  end

  context "find_or_set" do
    it "should create a non existant setting" do
      @created = RefinerySetting.find_or_set(:creating_from_scratch, 'I am a setting being created', :scoping => 'rspec_testing')

      @created.should == "I am a setting being created"
    end

    it "should not override an existing setting" do
      @created = RefinerySetting.set(:creating_from_scratch, {:value => 'I am a setting being created', :scoping => 'rspec_testing'})
      @created.should == "I am a setting being created"

      @find_or_set_created = RefinerySetting.find_or_set(:creating_from_scratch, 'Trying to change an existing value', :scoping => 'rspec_testing')

      @created.should == "I am a setting being created"
    end

    it "should work without scoping" do
      RefinerySetting.find_or_set(:rspec_testing_creating_from_scratch, 'Yes it worked').should == 'Yes it worked'
    end
  end

end

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
  end
  
  context "get" do
    it "should retrieve a seting that was created" do
      @set = RefinerySetting.set(:creating_from_scratch, {:value => "some value", :scoping => 'rspec_testing'})
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

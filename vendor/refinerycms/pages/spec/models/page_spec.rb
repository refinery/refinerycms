require 'spec_helper'

describe Page do
  
  def reset_page(options = {})
    @valid_attributes = {
      :title => "RSpec is great for testing too",
      :deletable => true
    }
    @page = Page.create!(@valid_attributes)
    @page.update_attributes(options)
  end
  
  def page_cannot_be_destroyed
    @page.destroy.should == false
  end
  
  def create_child
    @child = @page.children.create(:title => 'The child page')
  end
  
  before(:each) do
    reset_page
  end
  
  context "cannot be deleted under certain rules" do
    it "if link_url is present" do
      reset_page({:link_url => '/plugin-name'})
      page_cannot_be_destroyed
    end
    
    
    it "if refinery team deems it so" do
      reset_page({:deletable => false})
      page_cannot_be_destroyed
    end
    
    it "if menu_match is present" do
      reset_page({:menu_match => '^/RSpec is great for testing too.*$'})
      page_cannot_be_destroyed
    end
    
    it "unless you really want it to! >:]" do
      reset_page
      @page.destroy!
    end
  end
  
  context "page urls" do
    it "should return a full path" do
      @page.path.should == 'RSpec is great for testing too'
    end
    
    it "and all of its parent page titles, reversed" do
      create_child
      @child.path.should == 'RSpec is great for testing too - The child page'
    end
    
    it "or normally ;-)" do
      create_child
      @child.path({:reversed => false}).should == 'The child page - RSpec is great for testing too'
    end
    
    it ".path() still responds to the deprecated boolean" do
      create_child
      @child.path(false).should == 'The child page - RSpec is great for testing too'
    end
  end
  
  
end


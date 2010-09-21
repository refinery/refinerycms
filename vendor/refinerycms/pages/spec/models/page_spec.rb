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
  
  before(:each) do
    reset_page
  end
  
  context "a page cannot delete under certain rules" do
    it "shouldn't allow me to destroy pages that are links" do
      reset_page({:link_url => '/plugin-name'})
      page_cannot_be_destroyed
    end
    
    
    it "cannot be deleted if refinery team deems it so" do
      reset_page({:deletable => false})
      page_cannot_be_destroyed
    end
    
    it "cannot be destroyed if have menu_match is filled out" do
      reset_page({:menu_match => '^/RSpec is great for testing too.*$'})
      page_cannot_be_destroyed
    end
    
    it "will destroy if you really want it to! >:]" do
      reset_page
      @page.destroy!
    end
  end
  
  
end


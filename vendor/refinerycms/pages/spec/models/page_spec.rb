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
  
  it "cannot delete under certain rules" do
    #don't allow me to destroy pages that are links
    reset_page({:link_url => '/plugin-name'})
    page_cannot_be_destroyed
    
    
    #often, refinery system pages are not deletable
    reset_page({:deletable => false})
    page_cannot_be_destroyed
    
    #don't delete pages that have menu_match filled out
    reset_page({:menu_match => '^/RSpec is great for testing too.*$'})
    page_cannot_be_destroyed
  end
  
  
  
end


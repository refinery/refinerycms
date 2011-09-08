require 'spec_helper'

module Refinery
  describe Pages::Options do    
    describe ".reset!" do      
      it "should set pages_per_dialog back to the default value" do
        Pages::Options.pages_per_dialog.should == Pages::Options::DEFAULT_PAGES_PER_DIALOG
        Pages::Options.pages_per_dialog += 1
        Pages::Options.pages_per_dialog.should_not == Pages::Options::DEFAULT_PAGES_PER_DIALOG
        Pages::Options.reset!
        Pages::Options.pages_per_dialog.should == Pages::Options::DEFAULT_PAGES_PER_DIALOG
      end
      
      it "should set pages_per_admin_index back to the default value" do
        Pages::Options.pages_per_admin_index.should == Pages::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
        Pages::Options.pages_per_admin_index += 1
        Pages::Options.pages_per_admin_index.should_not == Pages::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
        Pages::Options.reset!
        Pages::Options.pages_per_admin_index.should == Pages::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
      end
    end
  end
end
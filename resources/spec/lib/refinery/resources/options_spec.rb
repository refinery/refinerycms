require 'spec_helper'

module Refinery
  describe Resources::Options do    
    describe ".reset!" do
      it "should set max_file_size back to the default value" do
        Resources::Options.max_file_size.should == Resources::Options::DEFAULT_MAX_FILE_SIZE
        Resources::Options.max_file_size += 1
        Resources::Options.max_file_size.should_not == Resources::Options::DEFAULT_MAX_FILE_SIZE
        Resources::Options.reset!
        Resources::Options.max_file_size.should == Resources::Options::DEFAULT_MAX_FILE_SIZE
      end
      
      it "should set pages_per_dialog back to the default value" do
        Resources::Options.pages_per_dialog.should == Resources::Options::DEFAULT_PAGES_PER_DIALOG
        Resources::Options.pages_per_dialog += 1
        Resources::Options.pages_per_dialog.should_not == Resources::Options::DEFAULT_PAGES_PER_DIALOG
        Resources::Options.reset!
        Resources::Options.pages_per_dialog.should == Resources::Options::DEFAULT_PAGES_PER_DIALOG
      end
      
      it "should set pages_per_admin_index back to the default value" do
        Resources::Options.pages_per_admin_index.should == Resources::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
        Resources::Options.pages_per_admin_index += 1
        Resources::Options.pages_per_admin_index.should_not == Resources::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
        Resources::Options.reset!
        Resources::Options.pages_per_admin_index.should == Resources::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
      end
    end
  end
end
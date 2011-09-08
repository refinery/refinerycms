require 'spec_helper'

module Refinery
  describe Images::Options do    
    describe ".reset!" do
      it "should set max_image_size back to the default value" do
        Images::Options.max_image_size.should == Images::Options::DEFAULT_MAX_IMAGE_SIZE
        Images::Options.max_image_size += 1
        Images::Options.max_image_size.should_not == Images::Options::DEFAULT_MAX_IMAGE_SIZE
        Images::Options.reset!
        Images::Options.max_image_size.should == Images::Options::DEFAULT_MAX_IMAGE_SIZE
      end
      
      it "should set pages_per_dialog back to the default value" do
        Images::Options.pages_per_dialog.should == Images::Options::DEFAULT_PAGES_PER_DIALOG
        Images::Options.pages_per_dialog += 1
        Images::Options.pages_per_dialog.should_not == Images::Options::DEFAULT_PAGES_PER_DIALOG
        Images::Options.reset!
        Images::Options.pages_per_dialog.should == Images::Options::DEFAULT_PAGES_PER_DIALOG
      end
      
      it "should set pages_per_dialog_that_have_size_options back to the default value" do
        Images::Options.pages_per_dialog_that_have_size_options.should == Images::Options::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
        Images::Options.pages_per_dialog_that_have_size_options += 1
        Images::Options.pages_per_dialog_that_have_size_options.should_not == Images::Options::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
        Images::Options.reset!
        Images::Options.pages_per_dialog_that_have_size_options.should == Images::Options::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
      end
      
      it "should set pages_per_admin_index back to the default value" do
        Images::Options.pages_per_admin_index.should == Images::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
        Images::Options.pages_per_admin_index += 1
        Images::Options.pages_per_admin_index.should_not == Images::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
        Images::Options.reset!
        Images::Options.pages_per_admin_index.should == Images::Options::DEFAULT_PAGES_PER_ADMIN_INDEX
      end
    end
  end
end
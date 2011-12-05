require 'spec_helper'

module Refinery
  describe Images do
    describe "#configure" do
      it "should set configurable option" do
        subject.configure do |config|
          config.max_image_size = 8201984
        end

        subject.max_image_size.should == 8201984
      end
    end

    describe ".reset!" do
      it "should set max_image_size back to the default value" do
        subject.config.max_image_size.should == subject::DEFAULT_MAX_IMAGE_SIZE
        subject.config.max_image_size += 1
        subject.config.max_image_size.should_not == subject::DEFAULT_MAX_IMAGE_SIZE
        subject.reset!
        subject.config.max_image_size.should == subject::DEFAULT_MAX_IMAGE_SIZE
      end

      it "should set pages_per_dialog back to the default value" do
        subject.config.pages_per_dialog.should == subject::DEFAULT_PAGES_PER_DIALOG
        subject.config.pages_per_dialog += 1
        subject.config.pages_per_dialog.should_not == subject::DEFAULT_PAGES_PER_DIALOG
        subject.reset!
        subject.config.pages_per_dialog.should == subject::DEFAULT_PAGES_PER_DIALOG
      end

      it "should set pages_per_dialog_that_have_size_options back to the default value" do
        subject.config.pages_per_dialog_that_have_size_options.should == subject::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
        subject.config.pages_per_dialog_that_have_size_options += 1
        subject.config.pages_per_dialog_that_have_size_options.should_not == subject::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
        subject.reset!
        subject.config.pages_per_dialog_that_have_size_options.should == subject::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
      end

      it "should set pages_per_admin_index back to the default value" do
        subject.config.pages_per_admin_index.should == subject::DEFAULT_PAGES_PER_ADMIN_INDEX
        subject.config.pages_per_admin_index += 1
        subject.config.pages_per_admin_index.should_not == subject::DEFAULT_PAGES_PER_ADMIN_INDEX
        subject.reset!
        subject.config.pages_per_admin_index.should == subject::DEFAULT_PAGES_PER_ADMIN_INDEX
      end
    end
  end
end

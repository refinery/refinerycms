require 'spec_helper'

module Refinery
  describe Images::Options do
    describe ".reset!" do
      it "should set max_image_size back to the default value" do
        subject.class.max_image_size.should == subject.class::DEFAULT_MAX_IMAGE_SIZE
        subject.class.max_image_size += 1
        subject.class.max_image_size.should_not == subject.class::DEFAULT_MAX_IMAGE_SIZE
        subject.class.reset!
        subject.class.max_image_size.should == subject.class::DEFAULT_MAX_IMAGE_SIZE
      end

      it "should set pages_per_dialog back to the default value" do
        subject.class.pages_per_dialog.should == subject.class::DEFAULT_PAGES_PER_DIALOG
        subject.class.pages_per_dialog += 1
        subject.class.pages_per_dialog.should_not == subject.class::DEFAULT_PAGES_PER_DIALOG
        subject.class.reset!
        subject.class.pages_per_dialog.should == subject.class::DEFAULT_PAGES_PER_DIALOG
      end

      it "should set pages_per_dialog_that_have_size_options back to the default value" do
        subject.class.pages_per_dialog_that_have_size_options.should == subject.class::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
        subject.class.pages_per_dialog_that_have_size_options += 1
        subject.class.pages_per_dialog_that_have_size_options.should_not == subject.class::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
        subject.class.reset!
        subject.class.pages_per_dialog_that_have_size_options.should == subject.class::DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
      end

      it "should set pages_per_admin_index back to the default value" do
        subject.class.pages_per_admin_index.should == subject.class::DEFAULT_PAGES_PER_ADMIN_INDEX
        subject.class.pages_per_admin_index += 1
        subject.class.pages_per_admin_index.should_not == subject.class::DEFAULT_PAGES_PER_ADMIN_INDEX
        subject.class.reset!
        subject.class.pages_per_admin_index.should == subject.class::DEFAULT_PAGES_PER_ADMIN_INDEX
      end
    end
  end
end

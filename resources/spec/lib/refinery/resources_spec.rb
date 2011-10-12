require 'spec_helper'

module Refinery
  describe Resources do
    describe "#configure" do
      it "should set configurable option" do
        subject.configure do |config|
          config.max_file_size = 8201984
        end

        subject.max_file_size.should == 8201984
      end
    end

    describe "#reset!" do
      it "should set max_file_size back to the default value" do
        subject.max_file_size.should == subject::DEFAULT_MAX_FILE_SIZE
        subject.max_file_size += 1
        subject.max_file_size.should_not == subject::DEFAULT_MAX_FILE_SIZE
        subject.reset!
        subject.max_file_size.should == subject::DEFAULT_MAX_FILE_SIZE
      end

      it "should set pages_per_dialog back to the default value" do
        subject.pages_per_dialog.should == subject::DEFAULT_PAGES_PER_DIALOG
        subject.pages_per_dialog += 1
        subject.pages_per_dialog.should_not == subject::DEFAULT_PAGES_PER_DIALOG
        subject.reset!
        subject.pages_per_dialog.should == subject::DEFAULT_PAGES_PER_DIALOG
      end

      it "should set pages_per_admin_index back to the default value" do
        subject.pages_per_admin_index.should == subject::DEFAULT_PAGES_PER_ADMIN_INDEX
        subject.pages_per_admin_index += 1
        subject.pages_per_admin_index.should_not == subject::DEFAULT_PAGES_PER_ADMIN_INDEX
        subject.reset!
        subject.pages_per_admin_index.should == subject::DEFAULT_PAGES_PER_ADMIN_INDEX
      end
    end
  end
end

require 'spec_helper'

module Refinery
  describe Resources do
    describe "#configure" do
      it "should set configurable option" do
        subject.configure do |config|
          config.max_file_size = 8201984
        end

        subject.config.max_file_size.should == 8201984
      end
    end

    describe "#reset!" do
      it "should set max_file_size back to the default value" do
        subject.config.max_file_size.should == subject::DEFAULT_MAX_FILE_SIZE
        subject.config.max_file_size += 1
        subject.config.max_file_size.should_not == subject::DEFAULT_MAX_FILE_SIZE
        subject.reset!
        subject.config.max_file_size.should == subject::DEFAULT_MAX_FILE_SIZE
      end

      it "should set pages_per_dialog back to the default value" do
        subject.config.pages_per_dialog.should == subject::DEFAULT_PAGES_PER_DIALOG
        subject.config.pages_per_dialog += 1
        subject.config.pages_per_dialog.should_not == subject::DEFAULT_PAGES_PER_DIALOG
        subject.reset!
        subject.config.pages_per_dialog.should == subject::DEFAULT_PAGES_PER_DIALOG
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

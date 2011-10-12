require 'spec_helper'

module Refinery
  describe Pages do
    describe "#configure" do
      it "should set configurable option" do
        subject.configure do |config|
          config.pages_per_dialog = 27
        end

        subject.pages_per_dialog.should == 27
      end
    end

    describe ".reset!" do
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

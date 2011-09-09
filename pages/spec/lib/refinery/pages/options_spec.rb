require 'spec_helper'

module Refinery
  describe Pages::Options do
    describe ".reset!" do
      it "should set pages_per_dialog back to the default value" do
        subject.class.pages_per_dialog.should == subject.class::DEFAULT_PAGES_PER_DIALOG
        subject.class.pages_per_dialog += 1
        subject.class.pages_per_dialog.should_not == subject.class::DEFAULT_PAGES_PER_DIALOG
        subject.class.reset!
        subject.class.pages_per_dialog.should == subject.class::DEFAULT_PAGES_PER_DIALOG
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

require 'spec_helper'

module Refinery
  describe Pages do
    describe "#configure" do
      it "should set configurable option" do
        subject.configure do |config|
          config.pages_per_dialog = (subject::DEFAULTS[:pages_per_admin_index] + 15)
        end

        subject.pages_per_dialog.should == (subject::DEFAULTS[:pages_per_admin_index] + 15)
      end
    end

    describe ".reset!" do
      it "should set pages_per_dialog back to the default value" do
        subject.pages_per_dialog.should == subject::DEFAULTS[:pages_per_dialog]
        subject.pages_per_dialog += 1
        subject.pages_per_dialog.should_not == subject::DEFAULTS[:pages_per_dialog]
        subject.reset!
        subject.pages_per_dialog.should == subject::DEFAULTS[:pages_per_dialog]
      end

      it "should set pages_per_admin_index back to the default value" do
        subject.pages_per_admin_index.should == subject::DEFAULTS[:pages_per_admin_index]
        subject.pages_per_admin_index += 1
        subject.pages_per_admin_index.should_not == subject::DEFAULTS[:pages_per_admin_index]
        subject.reset!
        subject.pages_per_admin_index.should == subject::DEFAULTS[:pages_per_admin_index]
      end
    end
  end
end

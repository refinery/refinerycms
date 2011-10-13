require 'spec_helper'

module Refinery
  describe Core do
    describe "#configure" do
      it "should set configurable option" do
        subject.configure do |config|
          config.rescue_not_found = true
        end

        subject.rescue_not_found.should == true
      end
    end

    describe ".reset!" do
      it "should set rescue_not_found back to the default value" do
        subject.rescue_not_found.should == subject::DEFAULT_RESCUE_NOT_FOUND
        subject.rescue_not_found = !subject::DEFAULT_RESCUE_NOT_FOUND
        subject.rescue_not_found.should_not == subject::DEFAULT_RESCUE_NOT_FOUND
        subject.reset!
        subject.rescue_not_found.should == subject::DEFAULT_RESCUE_NOT_FOUND
      end
    end
  end
end

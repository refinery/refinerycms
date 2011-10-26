require 'spec_helper'

describe Refinery do
  describe "#engines" do
    it "should return an array of modules representing registered engines" do
      subject.engines.should be_a(Array)
      subject.engines.each do |e|
        e.should be_a(Module)
      end
    end
  end

  describe "#register_engine" do
    before(:each) { subject.engines.clear }

    it "should add the engine's module to the array of registered engines" do
      subject.register_engine(Refinery::Core)

      Refinery.engines.should include(Refinery::Core)
      Refinery.engines.should have(1).item
    end

    it "should not allow same engine to be registered twice" do
      subject.register_engine(Refinery::Core)
      subject.register_engine(Refinery::Core)

      Refinery.engines.should have(1).item
    end
  end

  describe "#engine_registered?" do
    context "with Refinery::Core::Engine registered" do
      before(:each) { subject.register_engine(Refinery::Core) }

      it "should return true if the engine is registered" do
        subject.engine_registered?(Refinery::Core).should == true
      end
    end

    context "with no engines registered" do
      before(:each) { subject.engines.clear }

      it "should return false if the engine is not registered" do
        subject.engine_registered?(Refinery::Core).should == false
      end
    end
  end

  describe "#unregister_engine" do
    before(:each) do
      subject.engines.clear
      subject.register_engine(Refinery::Images)
    end

    it "should remove the engine's module from the array of registered engines" do
      subject.unregister_engine(Refinery::Images)

      subject.engines.should have(0).item
    end
  end

  describe "#validate_engine!" do
    context "with a valid engine" do
      it "should return true" do
        subject.send(:validate_engine!, Refinery::ValidEngine)
      end
    end

    context "with an invalid engine" do
      it "should raise invalid engine exception" do
        lambda {
          subject.send(:validate_engine!, Refinery::InvalidEngine)
        }.should raise_error(Refinery::InvalidEngineError, "Engine must define a root accessor that returns a pathname to it it's root")
      end
    end
  end

  describe "#roots" do
    it "should return pathname to engine root when given constant as parameter" do
      subject.roots(Refinery::Core).should == Refinery::Core.root
    end

    it "should return pathname to engine root when given symbol as parameter" do
      subject.roots(:'refinery/core').should == Refinery::Core.root
    end

    it "should return pathname to engine root when given string as parameter" do
      subject.roots("refinery/core").should == Refinery::Core.root
    end

    it "should return an array of all pathnames if no engine_name is specified" do
      subject.roots.should be_a(Array)
      subject.roots.each do |root|
        root.should be_a(Pathname)
      end
    end
  end
end

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

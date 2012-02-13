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
      it "should return nil" do
        subject.send(:validate_engine!, Refinery::ValidEngine).should be_nil
      end
    end

    context "with an invalid engine" do
      it "should raise invalid engine exception" do
        lambda {
          subject.send(:validate_engine!, Refinery::InvalidEngine)
        }.should raise_error(Refinery::InvalidEngineError, "Engine must define a root accessor that returns a pathname to its root")
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

  describe "#deprecate" do
    before(:each) do
      @errors = StringIO.new
      @old_err = $stderr
      $stderr = @errors
    end

    after(:each) { $stderr = @old_err }

    it "shows a deprecation warning" do
      Refinery.deprecate("ugis")
      @errors.rewind
      @errors.read.should == "\n-- DEPRECATION WARNING --\nThe use of 'ugis' is deprecated.\n"
    end

    it "takes when option" do
      Refinery.deprecate("ugis", :when => "10.0")
      @errors.rewind
      @errors.read.should == "\n-- DEPRECATION WARNING --\nThe use of 'ugis' is deprecated and will be removed at version 10.0.\n"
    end

    it "takes replacement option" do
      Refinery.deprecate("ugis", :when => "10.0", :replacement => "philip")
      @errors.rewind
      @errors.read.should == "\n-- DEPRECATION WARNING --\nThe use of 'ugis' is deprecated and will be removed at version 10.0.\nPlease use philip instead.\n"
    end
  end

  describe "#i18n_enabled?" do
    it "returns true when Refinery::I18n.enabled? is true" do
      Refinery::I18n.stub(:enabled?).and_return(true)
      subject.i18n_enabled?.should == true
    end

    it "returns false when Refinery::I18n.enabled? is false" do
      Refinery::I18n.stub(:enabled?).and_return(false)
      subject.i18n_enabled?.should == false
    end
  end

  describe ".route_for_model" do
    context "when passed Refinery::Dummy" do
      it "returns admin_dummy_path" do
        Refinery.route_for_model("Refinery::Dummy").should == "admin_dummy_path"
      end
    end

    context "when passed Refinery::Dummy and true" do
      it "returns admin_dummies_path" do
        Refinery.route_for_model("Refinery::Dummy", true).should == "admin_dummies_path"
      end
    end

    context "when passed Refinery::DummyName" do
      it "returns admin_dummy_name_path" do
        Refinery.route_for_model("Refinery::DummyName").should == "admin_dummy_name_path"
      end
    end

    context "when passed Refinery::DummyName and true" do
      it "returns admin_dummy_names_path" do
        Refinery.route_for_model("Refinery::DummyName", true).should == "admin_dummy_names_path"
      end
    end

    context "when passed Refinery::Dummy::Name" do
      it "returns dummy_admin_name_path" do
        Refinery.route_for_model("Refinery::Dummy::Name").should == "dummy_admin_name_path"
      end
    end

    context "when passed Refinery::Dummy::Name and true" do
      it "returns dummy_admin_names_path" do
        Refinery.route_for_model("Refinery::Dummy::Name", true).should == "dummy_admin_names_path"
      end
    end
  end
end

require 'spec_helper'

describe Refinery do
  describe "#include_once" do
    it "shouldn't double include a module" do
      mod = Module.new do
        def self.included(base)
          base::INCLUSIONS << self
          super
        end
      end

      [Module.new, Class.new].each do |target|
        target::INCLUSIONS = []
        subject.include_once(target, mod)
        subject.include_once(target, mod)
        target::INCLUSIONS.should have(1).item
      end
    end
  end

  describe "#extensions" do
    it "should return an array of modules representing registered extensions" do
      subject.extensions.should be_a(Array)
      subject.extensions.each do |e|
        e.should be_a(Module)
      end
    end
  end

  describe "#register_extension" do
    before { subject.extensions.clear }

    it "should add the extension's module to the array of registered extensions" do
      subject.register_extension(Refinery::Core)

      Refinery.extensions.should include(Refinery::Core)
      Refinery.extensions.should have(1).item
    end

    it "should not allow same extension to be registered twice" do
      subject.register_extension(Refinery::Core)
      subject.register_extension(Refinery::Core)

      Refinery.extensions.should have(1).item
    end
  end

  describe "#extension_registered?" do
    context "with Refinery::Core::Engine registered" do
      before { subject.register_extension(Refinery::Core) }

      it "should return true if the extension is registered" do
        subject.extension_registered?(Refinery::Core).should == true
      end
    end

    context "with no extensions registered" do
      before { subject.extensions.clear }

      it "should return false if the extension is not registered" do
        subject.extension_registered?(Refinery::Core).should == false
      end
    end
  end

  describe "#unregister_extension" do
    before do
      subject.extensions.clear
      subject.register_extension(Refinery::Images)
    end

    it "should remove the extension's module from the array of registered extensions" do
      subject.unregister_extension(Refinery::Images)

      subject.extensions.should have(0).item
    end
  end

  describe "#validate_extension!" do
    context "with a valid extension" do
      it "should return nil" do
        subject.send(:validate_extension!, Refinery::ValidEngine).should be_nil
      end
    end

    context "with an invalid extension" do
      it "should raise invalid extension exception" do
        lambda {
          subject.send(:validate_extension!, Refinery::InvalidEngine)
        }.should raise_error(Refinery::InvalidEngineError, "Engine must define a root accessor that returns a pathname to its root")
      end
    end
  end

  describe "#roots" do
    it "should return pathname to extension root when given constant as parameter" do
      subject.roots(Refinery::Core).should == Refinery::Core.root
    end

    it "should return pathname to extension root when given symbol as parameter" do
      subject.roots(:'refinery/core').should == Refinery::Core.root
    end

    it "should return pathname to extension root when given string as parameter" do
      subject.roots("refinery/core").should == Refinery::Core.root
    end

    it "should return an array of all pathnames if no extension_name is specified" do
      subject.roots.should be_a(Array)
      subject.roots.each do |root|
        root.should be_a(Pathname)
      end
    end
  end

  describe "#deprecate" do
    before do
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

  describe ".route_for_model" do
    context 'with Refinery::Dummy' do
      module Refinery::Dummy
      end

      it "returns admin_dummy_path" do
        Refinery.route_for_model(Refinery::Dummy).should == "admin_dummy_path"
      end

      context ":plural => true" do
        it "returns admin_dummies_path" do
          Refinery.route_for_model(Refinery::Dummy, :plural => true).should == "admin_dummies_path"
        end
      end
    end

    context 'with Refinery::GroupClass' do
      module Refinery::GroupClass
      end

      it "returns admin_group_class_path" do
        Refinery.route_for_model(Refinery::GroupClass).should == "admin_group_class_path"
      end
    end

    context 'with Refinery::DummyName' do
      module Refinery::DummyName
      end

      it "returns admin_dummy_name_path" do
        Refinery.route_for_model(Refinery::DummyName).should == "admin_dummy_name_path"
      end

      context ":plural => true" do
        it "returns admin_dummy_names_path" do
          Refinery.route_for_model(Refinery::DummyName, :plural => true).should == "admin_dummy_names_path"
        end
      end
    end

    context 'with Refinery::Dummy::Name' do
      module Refinery::Dummy
        module Name
        end
      end

      it "returns dummy_admin_name_path" do
        Refinery.route_for_model(Refinery::Dummy::Name).should == "dummy_admin_name_path"
      end

      context ":plural => true" do
        it "returns dummy_admin_names_path" do
          Refinery.route_for_model(Refinery::Dummy::Name, :plural => true).should == "dummy_admin_names_path"
        end
      end

      context ":admin => false" do
        it "returns dummy_name_path" do
          Refinery.route_for_model(Refinery::Dummy::Name, :admin => false).should == 'dummy_name_path'
        end
      end

      context ":admin => false, :plural => true" do
        it "returns dummy_names_path" do
          Refinery.route_for_model(Refinery::Dummy::Name, :admin => false, :plural => true).should == 'dummy_names_path'
        end
      end
    end
  end

  describe Refinery::Core::Engine do
    describe "#helpers" do
      it "should not include ApplicationHelper" do
        Refinery::Core::Engine.helpers.ancestors.map(&:name).should_not include("ApplicationHelper")
      end
    end
  end
end

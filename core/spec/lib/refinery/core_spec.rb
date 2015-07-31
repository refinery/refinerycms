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
        expect(target::INCLUSIONS.size).to eq(1)
      end
    end
  end

  describe "#extensions" do
    it "should return an array of modules representing registered extensions" do
      expect(subject.extensions).to be_a(Array)
      subject.extensions.each do |e|
        expect(e).to be_a(Module)
      end
    end
  end

  describe "#register_extension" do
    before { subject.extensions.clear }

    it "should add the extension's module to the array of registered extensions" do
      subject.register_extension(Refinery::Core)

      expect(Refinery.extensions).to include(Refinery::Core)
      expect(Refinery.extensions.size).to eq(1)
    end

    it "should not allow same extension to be registered twice" do
      subject.register_extension(Refinery::Core)
      subject.register_extension(Refinery::Core)

      expect(Refinery.extensions.size).to eq(1)
    end
  end

  describe "#extension_registered?" do
    context "with Refinery::Core::Engine registered" do
      before { subject.register_extension(Refinery::Core) }

      it "should return true if the extension is registered" do
        expect(subject.extension_registered?(Refinery::Core)).to eq(true)
      end
    end

    context "with no extensions registered" do
      before { subject.extensions.clear }

      it "should return false if the extension is not registered" do
        expect(subject.extension_registered?(Refinery::Core)).to eq(false)
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

      expect(subject.extensions.size).to eq(0)
    end
  end

  describe "#validate_extension!" do
    context "with a valid extension" do
      it "should return nil" do
        expect(subject.send(:validate_extension!, Refinery::ValidEngine)).to be_nil
      end
    end

    context "with an invalid extension" do
      it "should raise invalid extension exception" do
        expect {
          subject.send(:validate_extension!, Refinery::InvalidEngine)
        }.to raise_error(::Refinery::InvalidEngineError)
      end
    end
  end

  describe "#roots" do
    it "should return pathname to extension root when given constant as parameter" do
      expect(subject.roots(Refinery::Core)).to eq(Refinery::Core.root)
    end

    it "should return pathname to extension root when given symbol as parameter" do
      expect(subject.roots(:'refinery/core')).to eq(Refinery::Core.root)
    end

    it "should return pathname to extension root when given string as parameter" do
      expect(subject.roots("refinery/core")).to eq(Refinery::Core.root)
    end

    it "should return an array of all pathnames if no extension_name is specified" do
      expect(subject.roots).to be_a(Array)
      subject.roots.each do |root|
        expect(root).to be_a(Pathname)
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
      expect(@errors.read).to eq("\n-- DEPRECATION WARNING --\nThe use of 'ugis' is deprecated.\n")
    end

    it "takes when option" do
      Refinery.deprecate("ugis", :when => "10.0")
      @errors.rewind
      expect(@errors.read).to eq("\n-- DEPRECATION WARNING --\nThe use of 'ugis' is deprecated and will be removed at version 10.0.\n")
    end

    it "takes replacement option" do
      Refinery.deprecate("ugis", :when => "10.0", :replacement => "philip")
      @errors.rewind
      expect(@errors.read).to eq("\n-- DEPRECATION WARNING --\nThe use of 'ugis' is deprecated and will be removed at version 10.0.\nPlease use philip instead.\n")
    end
  end

  describe ".route_for_model" do
    context 'with Refinery::Dummy' do
      module Refinery::Dummy
      end

      it "returns admin_dummy_path" do
        expect(Refinery.route_for_model(Refinery::Dummy)).to eq("admin_dummy_path")
      end

      context ":plural => true" do
        it "returns admin_dummies_path" do
          expect(Refinery.route_for_model(Refinery::Dummy, :plural => true)).to eq("admin_dummies_path")
        end
      end
    end

    context 'with Refinery::GroupClass' do
      module Refinery::GroupClass
      end

      it "returns admin_group_class_path" do
        expect(Refinery.route_for_model(Refinery::GroupClass)).to eq("admin_group_class_path")
      end
    end

    context 'with Refinery::DummyName' do
      module Refinery::DummyName
      end

      it "returns admin_dummy_name_path" do
        expect(Refinery.route_for_model(Refinery::DummyName)).to eq("admin_dummy_name_path")
      end

      context ":plural => true" do
        it "returns admin_dummy_names_path" do
          expect(Refinery.route_for_model(Refinery::DummyName, :plural => true)).to eq("admin_dummy_names_path")
        end
      end
    end

    context 'with Refinery::Dummy::Name' do
      module Refinery::Dummy
        module Name
        end
      end

      it "returns dummy_admin_name_path" do
        expect(Refinery.route_for_model(Refinery::Dummy::Name)).to eq("dummy_admin_name_path")
      end

      context ":plural => true" do
        it "returns dummy_admin_names_path" do
          expect(Refinery.route_for_model(Refinery::Dummy::Name, :plural => true)).to eq("dummy_admin_names_path")
        end
      end

      context ":admin => false" do
        it "returns dummy_name_path" do
          expect(Refinery.route_for_model(Refinery::Dummy::Name, :admin => false)).to eq('dummy_name_path')
        end
      end

      context ":admin => false, :plural => true" do
        it "returns dummy_names_path" do
          expect(Refinery.route_for_model(Refinery::Dummy::Name, :admin => false, :plural => true)).to eq('dummy_names_path')
        end
      end
    end
  end

  describe Refinery::Core::Engine do
    describe "#helpers" do
      it "should not include ApplicationHelper" do
        expect(Refinery::Core::Engine.helpers.ancestors.map(&:name)).not_to include("ApplicationHelper")
      end
    end
  end

  describe "backend_path" do
    let(:root_path) { "/custom/path" }

    it "should take into account the mount point" do
      allow(Refinery::Core).to receive(:mounted_path).and_return(root_path)
      expect(Refinery::Core.backend_path).to eq("#{root_path}/refinery")
    end
  end
end

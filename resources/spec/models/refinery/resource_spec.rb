require 'spec_helper'

module Refinery
  describe Resource do
    let(:resource) { FactoryGirl.create(:resource) }

    context "with valid attributes" do
      it "should create successfully" do
        resource.errors.should be_empty
      end
    end

    context "resource url" do
      it "should respond to .url" do
        resource.should respond_to(:url)
      end

      it "should not support thumbnailing like images do" do
        resource.should_not respond_to(:thumbnail)
      end

      it "should contain its filename at the end" do
        expect(resource.url.split('/').last).to match(/\A#{resource.file_name}/)
      end
    end

    describe "#type_of_content" do
      it "returns formated mime type" do
        resource.type_of_content.should == "text plain"
      end
    end

    describe "#title" do
      it "returns a titleized version of the filename" do
        resource.title.should == "Refinery Is Awesome"
      end
    end

    describe ".per_page" do
      context "dialog is true" do
        it "returns resource count specified by Resources.pages_per_dialog option" do
          Resource.per_page(true).should == Resources.pages_per_dialog
        end
      end

      context "dialog is false" do
        it "returns resource count specified by Resources.pages_per_admin_index constant" do
          Resource.per_page.should == Resources.pages_per_admin_index
        end
      end
    end

    describe ".create_resources" do
      let(:file) { Refinery.roots('refinery/resources').join("spec/fixtures/refinery_is_awesome.txt") }

      context "only one resource uploaded" do
        it "returns an array containing one resource" do
          Resource.create_resources(:file => file).should have(1).item
        end
      end

      context "many resources uploaded at once" do
        it "returns an array containing all those resources" do
          Resource.create_resources(:file => [file, file, file]).should have(3).items
        end
      end

      specify "each returned array item should be an instance of resource" do
        Resource.create_resources(:file => [file, file, file]).each do |r|
          r.should be_an_instance_of(Resource)
        end
      end

      specify "each returned array item should be passed form parameters" do
        params = {:file => [file, file, file], :fake_param => 'blah'}

        Resource.should_receive(:create).exactly(3).times.with({:file => file, :fake_param => 'blah'})
        Resource.create_resources(params)
      end
    end

    describe "validations" do
      describe "valid #file" do
        before do
          @file = Refinery.roots('refinery/resources').join("spec/fixtures/refinery_is_awesome.txt")
          Resources.max_file_size = (File.read(@file).size + 10)
        end

        it "should be valid when size does not exceed .max_file_size" do
          Resource.new(:file => @file).should be_valid
        end
      end

      describe "too large #file" do
        before do
          @file = Refinery.roots('refinery/resources').join("spec/fixtures/refinery_is_awesome.txt")
          Resources.max_file_size = (File.read(@file).size - 10)
          @resource = Resource.new(:file => @file)
        end

        it "should not be valid when size exceeds .max_file_size" do
          @resource.should_not be_valid
        end

        it "should contain an error message" do
          @resource.valid?
          @resource.errors.should_not be_empty
          @resource.errors[:file].should == Array(::I18n.t(
            'too_big', :scope => 'activerecord.errors.models.refinery/resource',
                       :size => Resources.max_file_size
          ))
        end
      end

      describe "invalid argument for #file" do
        before do
          @resource = Resource.new
        end

        it "has an error message" do
          @resource.valid?
          @resource.errors.should_not be_empty
          @resource.errors[:file].should == Array(::I18n.t(
            'blank', :scope => 'activerecord.errors.models.refinery/resource'
          ))
        end
      end
    end
  end
end

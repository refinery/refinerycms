require 'spec_helper'

module Refinery
  describe Resource, :type => :model do
    let(:resource) { FactoryGirl.create(:resource) }
    let(:titled_resource) { FactoryGirl.create(:resource, resource_title: 'Resource Title')}

    context "with valid attributes" do
      it "should create successfully" do
        expect(resource.errors).to be_empty
      end
    end

    context "resource url" do
      it "should respond to .url" do
        expect(resource).to respond_to(:url)
      end

      it "should not support thumbnailing like images do" do
        expect(resource).not_to respond_to(:thumbnail)
      end

      it "should contain its filename at the end" do
        expect(resource.url.split('/').last).to match(/\A#{resource.file_name}/)
      end

      context "when Dragonfly.verify_urls is true" do
        before do
          allow(Refinery::Resources).to receive(:dragonfly_verify_urls).and_return(true)
          ::Refinery::Resources::Dragonfly.configure!
        end

        it "returns a url with an SHA parameter" do
          expect(resource.url).to match(/\?sha=[\da-fA-F]{16}\z/)
        end
      end

      context "when Dragonfly.verify_urls is false" do
        before do
          allow(Refinery::Resources).to receive(:dragonfly_verify_urls).and_return(false)
          ::Refinery::Resources::Dragonfly.configure!
        end
        it "returns a url without an SHA parameter" do
          expect(resource.url).not_to match(/\?sha=[\da-fA-F]{16}\z/)
        end
      end
    end

    describe "#type_of_content" do
      it "returns formated mime type" do
        expect(resource.type_of_content).to eq("text plain")
      end
    end

    describe "#title" do
      context 'when a specific title has not been given' do
        it "returns a titleized version of the filename" do
          expect(resource.title).to eq("Refinery Is Awesome")
        end
      end
      context 'when a specific title has been given' do
        it 'returns that title' do
          expect(titled_resource.title).to eq('Resource Title')
        end
      end
    end

    describe ".per_page" do
      context "dialog is true" do
        it "returns resource count specified by Resources.pages_per_dialog option" do
          expect(Resource.per_page(true)).to eq(Resources.pages_per_dialog)
        end
      end

      context "dialog is false" do
        it "returns resource count specified by Resources.pages_per_admin_index constant" do
          expect(Resource.per_page).to eq(Resources.pages_per_admin_index)
        end
      end
    end

    describe ".create_resources" do
      let(:file) { Refinery.roots('refinery/resources').join("spec/fixtures/refinery_is_awesome.txt") }

      context "only one resource uploaded" do
        it "returns an array containing one resource" do
          expect(Resource.create_resources(:file => file).size).to eq(1)
        end
      end

      context "many resources uploaded at once" do
        it "returns an array containing all those resources" do
          expect(Resource.create_resources(:file => [file, file, file]).size).to eq(3)
        end
      end

      specify "each returned array item should be an instance of resource" do
        Resource.create_resources(:file => [file, file, file]).each do |r|
          expect(r).to be_an_instance_of(Resource)
        end
      end

      specify "each returned array item should be passed form parameters" do
        params = {:file => [file, file, file], :fake_param => 'blah'}

        expect(Resource).to receive(:create).exactly(3).times.with({:file => file, :fake_param => 'blah'})
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
          expect(Resource.new(:file => @file)).to be_valid
        end
      end

      describe "too large #file" do
        before do
          @file = Refinery.roots('refinery/resources').join("spec/fixtures/refinery_is_awesome.txt")
          Resources.max_file_size = (File.read(@file).size - 10)
          @resource = Resource.new(:file => @file)
        end

        it "should not be valid when size exceeds .max_file_size" do
          expect(@resource).not_to be_valid
        end

        it "should contain an error message" do
          @resource.valid?
          expect(@resource.errors).not_to be_empty
          expect(@resource.errors[:file]).to eq(Array(::I18n.t(
            'too_big', :scope => 'activerecord.errors.models.refinery/resource',
                       :size => Resources.max_file_size
          )))
        end
      end

      describe "invalid argument for #file" do
        before do
          @resource = Resource.new
        end

        it "has an error message" do
          @resource.valid?
          expect(@resource.errors).not_to be_empty
          expect(@resource.errors[:file]).to eq(Array(::I18n.t(
            'blank', :scope => 'activerecord.errors.models.refinery/resource'
          )))
        end
      end
    end
  end
end

require "spec_helper"
require "rake"

describe "CLI" do
  let(:rake) { Rake::Application.new }

  before do
    Rake.application = rake
    load File.expand_path("../../../../lib/tasks/refinery.rake", __FILE__)
    Rake::Task.define_task(:environment)
  end

  context "when called with no args" do
    it "shows info message" do
      msg = capture(:stdout) { rake["refinery:override"].invoke }
    
      msg.should eq(
        <<-MSG
You didn't specify anything to override. Here are some examples:
rake refinery:override view=pages/home
rake refinery:override view=refinery/pages/home
rake refinery:override view=**/*menu
rake refinery:override view=_menu_branch
rake refinery:override javascript=admin
rake refinery:override javascript=refinery/site_bar
rake refinery:override stylesheet=home
rake refinery:override stylesheet=refinery/site_bar
rake refinery:override controller=pages
rake refinery:override model=page
rake refinery:override model=refinery/page
        MSG
      )
    end
  end

  shared_examples "refinery:override" do
    context "specified file doesn't exist" do
      it "shows message" do
        ENV[env] = "non-existent"
      
        msg = capture(:stdout) { rake["refinery:override"].invoke }

        msg.should eq(not_found_message)
      end
    end

    context "specified file exist" do
      let (:file_name) do 
        Dir.entries(file_location).reject { |e| e =~ %r{^\.+} || e !~ %r{\..+} }.first
      end
      
      after do
        FileUtils.rm_f(Rails.root.join(copied_file_location))
        ENV[env] = nil
      end

      it "copies file to app folder" do
        ENV[env] = env_file_location

        msg = capture(:stdout) { rake["refinery:override"].invoke }

        msg.should eq(spec_success_message)
        File.exists?(Rails.root.join(copied_file_location)).should be_true
      end
    end
  end

  describe "overriding views" do
    it_behaves_like "refinery:override" do
      let(:env) { "view" }
      let(:not_found_message) { "Couldn't match any view template files in any extensions like non-existent\n" }
      let(:spec_success_message) { "Copied view template file to app/views/refinery/#{file_name}\n" }
      let(:file_location) { File.expand_path("../../../../app/views/refinery", __FILE__) }
      let(:env_file_location) { "refinery/#{file_name.sub(%r{\..+}, "")}" }
      let(:copied_file_location) { "app/views/refinery/#{file_name}" }
    end
  end

  describe "overriding controllers" do
    it_behaves_like "refinery:override" do
      let(:env) { "controller" }
      let(:not_found_message) { "Couldn't match any controller files in any extensions like non-existent\n" }
      let(:spec_success_message) { "Copied controller file to app/controllers/refinery/#{file_name}\n" }
      let(:file_location) { File.expand_path("../../../../app/controllers/refinery", __FILE__) }
      let(:env_file_location) { "refinery/#{file_name.sub(%r{\..+}, "")}" }
      let(:copied_file_location) { "app/controllers/refinery/#{file_name}" }
    end
  end

  describe "overriding models" do
    it_behaves_like "refinery:override" do
      let(:env) { "model" }
      let(:not_found_message) { "Couldn't match any model files in any extensions like non-existent\n" }
      let(:spec_success_message) { "Copied model file to app/models/refinery/core/#{file_name}\n" }
      let(:file_location) { File.expand_path("../../../../app/models/refinery/core", __FILE__) }
      let(:env_file_location) { "refinery/core/#{file_name.sub(%r{\..+}, "")}" }
      let(:copied_file_location) { "app/models/refinery/core/#{file_name}" }
    end
  end

  describe "overriding javascripts" do
    it_behaves_like "refinery:override" do
      let(:env) { "javascript" }
      let(:not_found_message) { "Couldn't match any javascript files in any extensions like non-existent\n" }
      let(:spec_success_message) { "Copied javascript file to app/assets/javascripts/refinery/#{file_name}\n" }
      let(:file_location) { File.expand_path("../../../../app/assets/javascripts/refinery", __FILE__) }
      let(:env_file_location) { "refinery/#{file_name.sub(%r{\..+}, "")}" }
      let(:copied_file_location) { "app/assets/javascripts/refinery/#{file_name}" }
    end
  end

  describe "overriding stylesheets" do
    it_behaves_like "refinery:override" do
      let(:env) { "stylesheet" }
      let(:not_found_message) { "Couldn't match any stylesheet files in any extensions like non-existent\n" }
      let(:spec_success_message) { "Copied stylesheet file to app/assets/stylesheets/refinery/#{file_name}\n" }
      let(:file_location) { File.expand_path("../../../../app/assets/stylesheets/refinery", __FILE__) }
      let(:env_file_location) { "refinery/#{file_name.sub(%r{\..+}, "")}" }
      let(:copied_file_location) { "app/assets/stylesheets/refinery/#{file_name}" }
    end
  end
end

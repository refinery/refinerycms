require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/cms/cms_generator'

module Refinery
  describe CmsGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../../../tmp", __FILE__)

    before do
      prepare_destination

      dir = "#{destination_root}/config/environments"
      FileUtils.mkdir_p(dir)
      File.open("#{dir}/development.rb", "w") do |file|
        file.write <<-SPEC
Dummy::Application.configure do
  config.action_mailer.test = true
end
        SPEC
      end

      File.open("#{dir}/test.rb", "w") do |file|
        file.write <<-SPEC
Dummy::Application.configure do
  # config.action_mailer.test = true
end
        SPEC
      end

      File.open("#{dir}/production.rb", "w") do |file|
        file.write <<-SPEC
Dummy::Application.configure do
  config.action_mailer.test = true
  config.action_mailer.check = {
    :test => true,
    :check => true
  }
end
        SPEC
      end

      run_generator %w[--skip-db --skip-migrations]
    end

    specify do
      destination_root.should have_structure {
        directory "app" do
          directory "decorators" do
            directory "controllers" do
              directory "refinery" do
                file ".gitkeep"
              end
            end
            directory "models" do
              directory "refinery" do
                file ".gitkeep"
              end
            end
          end
          directory "views" do
            directory "sitemap" do
              file "index.xml.builder"
            end
          end
        end
        directory "config" do
          file "database.yml.mysql"
          file "database.yml.postgresql"
          file "database.yml.sqlite3"
        end
      }
    end

    describe "#ensure_environments_are_sane" do
      it "wraps single line config.action_mailer setting" do
        File.open("#{destination_root}/config/environments/development.rb") do |file|
          file.read.should eq <<-SPEC
Dummy::Application.configure do
  if config.respond_to?(:action_mailer)
    config.action_mailer.test = true
  end
end
          SPEC
        end
      end

      it "wraps multi line config.action_mailer settings" do
        File.open("#{destination_root}/config/environments/production.rb") do |file|
          file.read.should eq <<-SPEC
Dummy::Application.configure do
  if config.respond_to?(:action_mailer)
    config.action_mailer.test = true
    config.action_mailer.check = {
      :test => true,
      :check => true
    }
  end
end
          SPEC
        end
      end
    end
  end
end

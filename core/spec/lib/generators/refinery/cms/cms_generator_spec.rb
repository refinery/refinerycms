require 'spec_helper'
require 'generator_spec/generator_example_group'
require 'generators/refinery/cms/cms_generator'

module Refinery
  describe CmsGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../../../tmp", __FILE__)

    before do
      prepare_destination

      File.write "#{destination_root}/Gemfile", ""

      dir = "#{destination_root}/config/environments"
      FileUtils.mkdir_p(dir)
      File.write "#{dir}/development.rb", <<-SPEC
Dummy::Application.configure do
  config.action_mailer.test = true
end
      SPEC

      File.write "#{dir}/test.rb", <<-SPEC
Dummy::Application.configure do
  # config.action_mailer.test = true
end
      SPEC

      File.write "#{dir}/production.rb", <<-SPEC
Dummy::Application.configure do
  config.action_mailer.test = true
  config.action_mailer.check = {
    :test => true,
    :check => true
  }
end
      SPEC

      copy_routes
      run_generator %w[--skip-db --skip-migrations]
    end

    specify do
      expect(destination_root).to have_structure {
        directory "app" do
          directory "decorators" do
            directory "controllers" do
              directory "refinery" do
                file ".keep"
              end
            end
            directory "models" do
              directory "refinery" do
                file ".keep"
              end
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
        expect(File.read("#{destination_root}/config/environments/development.rb")).to eq <<-SPEC
Dummy::Application.configure do
  if config.respond_to?(:action_mailer)
    config.action_mailer.test = true
  end
end
        SPEC
      end

      it "wraps multi line config.action_mailer settings" do
        expect(File.read("#{destination_root}/config/environments/production.rb")).to eq <<-SPEC
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

    describe "#mount!" do
      it 'adds Refinery to routes.rb' do
        expect(File.read("#{destination_root}/config/routes.rb")).to match /Refinery/
      end
    end

    def copy_routes
      routes = File.join(Gem.loaded_specs['railties'].full_gem_path, 'lib', 'rails', 'generators', 'rails', 'app', 'templates', 'config', 'routes.rb')
      destination = File.join(destination_root, "config")

      FileUtils.mkdir_p(destination)
      FileUtils.cp routes, destination
    end

  end
end

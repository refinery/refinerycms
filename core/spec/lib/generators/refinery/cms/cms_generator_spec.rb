require 'spec_helper'
require 'generator_spec/test_case'
require 'generators/refinery/cms/cms_generator'

module Refinery
  describe CmsGenerator do
    include GeneratorSpec::TestCase
    destination File.expand_path("../../../../../../tmp", __FILE__)

    before(:each) do
      prepare_destination
      run_generator
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
          directory "initializers" do
            file "devise.rb"
          end
        end
      }
    end
  end
end

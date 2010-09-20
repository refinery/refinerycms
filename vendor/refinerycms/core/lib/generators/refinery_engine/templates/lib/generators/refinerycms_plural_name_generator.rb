# this will move into Refinery itself
require 'rails/generators'
require 'rails/generators/migration'

module Refinery
  module Generators
    class EngineInstaller < Rails::Generators::Base
      include Rails::Generators::Migration
      
      def generate
        Dir.glob(File.expand_path('../templates/db/**', __FILE__)).each do |path|
          unless File.directory?(path)
            migration_template plugin_path_for(path)
          end
        end
      end

    protected

      def plugin_path_for(path)
        path = path.gsub(File.dirname(__FILE__) + "../../db/migrate", "db/migrate")
        path = path.gsub("plural_name", plural_name)
        path = path.gsub("singular_name", singular_name)
      end
    end
  end
end


# This stays.
class Refinerycms<%= class_name.pluralize %> < Refinery::Generators::EngineInstaller
  source_root File.expand_path('../../', __FILE__)
end
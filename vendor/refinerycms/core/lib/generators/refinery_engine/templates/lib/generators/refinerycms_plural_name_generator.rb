# this will move into Refinery itself
require 'rails/generators'
require 'rails/generators/migration'

module Refinery
  module Generators
    class EngineInstaller < Rails::Generators::Base
      include Rails::Generators::Migration
      
      # Implement the required interface for Rails::Generators::Migration.
      # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
      
      def generate
        Dir.glob(File.expand_path('../../../db/**/**', __FILE__)).each do |path|
          unless File.directory?(path)
            if path =~ /.*migrate.*/
              migration_template plugin_path_for(path)
            else
              template plugin_path_for(path)
            end
          end
        end
      end

    protected

      def plugin_path_for(path)
        puts path
        path = path.gsub(File.dirname(__FILE__) + "../db", "db")
      end
    end
  end
end

# Below is a hack until this issue:
# https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
# is fixed on the Rails project.

require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'active_record'

module ActiveRecord
  module Generators
    class Base < Rails::Generators::NamedBase #:nodoc:
      include Rails::Generators::Migration

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end
    end
  end
end


# This stays.
class Refinerycms<%= class_name.pluralize %> < Refinery::Generators::EngineInstaller
  source_root File.expand_path('../../', __FILE__)
end
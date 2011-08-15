require 'refinerycms-base'
require File.expand_path('../refinery/generators', __FILE__)

module Refinery
  module Generators
    
    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end
    
    class Engine < Rails::Engine
      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_generators"
          plugin.hide_from_menu = true
          plugin.pathname = root
        end
      end
    end
  end
end

# Below is a hack until this issue:
# https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
# is fixed on the Rails project.
require 'rails/generators'
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
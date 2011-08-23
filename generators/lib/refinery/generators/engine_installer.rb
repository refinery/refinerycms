require File.expand_path('../../generators', __FILE__)
require 'rails/generators'
require 'rails/generators/named_base'
require 'rails/generators/migration'

module Refinery
  module Generators
    # The core engine installer streamlines the installation of custom generated
    # engines. It takes the migrations and seeds in your engine and moves them
    # into the rails app db directory, ready to migrate.
    class EngineInstaller < Rails::Generators::Base

      include Rails::Generators::Migration

      attr_accessor :silence_puts
      def silence_puts
        !!@silence_puts
      end

      class << self

        def engine_name(name = nil)
          @engine_name = name.to_s unless name.nil?
          @engine_name
        end

        def source_root(root = nil)
          Pathname.new(super.to_s)
        end

        # Implement the required interface for Rails::Generators::Migration.
        # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
        # can be removed once this issue is fixed:
        # # https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
        def next_migration_number(dirname)
          ::ActiveRecord::Generators::Base.next_migration_number(dirname)
        end
      end

      def initialize(args = [], options = {}, config = {})
        config[:destination_root] = config[:destination_root] || Rails.root.to_s
        super(args, options, config)
      end

      def generate
        Pathname.glob(self.class.source_root.join('db', '**', '*.rb')).sort.each do |path|
          case path.to_s
          when %r{.*/migrate/.*}
            # unless the migration has already been generated.
            migration_name = "#{path.split.last.to_s.split(/^\d+_/).last}"
            unless Dir[destination_path.join('db', 'migrate', "*#{migration_name}")].any?
              migration_template path,destination_path.join('db', 'migrate', migration_name)
            else
              puts "You already have a migration called #{migration_name.split('.rb').first}" unless self.silence_puts || self.behavior == :revoke
            end
          when %r{.*/seeds/.*}
            template path, destination_path.join('db', 'seeds', path.to_s.split('/seeds/').last)
          end
        end

        if !self.silence_puts && self.behavior != :revoke
          puts "------------------------"
          puts "Now run:"
          puts "rake db:migrate"
          puts "------------------------"
        elsif self.behavior == :revoke
          ::Refinery::Generators::Migrations.revoke({
            :pattern => self.class.source_root.join('db', 'migrate', '*.rb')
          })
        end
      end

      protected

        # Helper method to quickly convert destination_root to a Pathname for easy file path manipulation
        def destination_path
          @destination_path ||= Pathname.new(self.destination_root)
        end
    end
  end
end

require 'rails/generators/migration'

class RefineryEngineGenerator < Rails::Generators::NamedBase

  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

  def generate
    unless attributes.empty?
      Dir.glob(File.expand_path('../templates/**/**', __FILE__)).each do |path|
        unless File.directory?(path)
          template path, plugin_path_for(path)
        end
      end

      # Update the gem file
      if Rails.env != 'test' and self.behavior != :revoke
        Rails.root.join('Gemfile').open('a') do |f|
          f.write "\ngem 'refinerycms-#{plural_name}', '1.0', :path => 'vendor/engines', :require => '#{plural_name}'"
        end

        puts "------------------------"
        puts "Now run:"
        puts "bundle install"
        puts "rake db:migrate"
        puts "------------------------"
      elsif self.behavior == :revoke
        lines = Rails.root.join('Gemfile').open('r').read.split("\n")
        Rails.root.join('Gemfile').open('w').puts(lines.reject {|l| l =~ %r{refinerycms-#{plural_name}}}.join("\n"))
      end
    else
      puts "You must specify at least one field. For help: rails generate refinery_engine"
    end
  end

protected

  def plugin_path_for(path)
    path = path.gsub(File.dirname(__FILE__) + "/templates/", "vendor/engines/#{plural_name}/")
    path = path.gsub("plural_name", plural_name)
    path = path.gsub("singular_name", singular_name)
    path = path.gsub(".migration", '')

    # hack can be removed after issue is fixed
    unless self.behavior == :revoke
     next_migration_number = ActiveRecord::Generators::Base.next_migration_number(File.dirname(__FILE__))
    else
      if (migrations = Dir[Rails.root.join('db', 'migrate', "*create_#{plural_name}*.rb").to_s]).any?
        next_migration_number = migrations.first.split('/').last.split('_').first
      else
        next_migration_number = ''
      end
    end
    path = path.gsub("migration_number", next_migration_number.to_s)

    # replace our local db path with the app one instead.
    path = path.gsub("/db/", "/../../../db/")
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

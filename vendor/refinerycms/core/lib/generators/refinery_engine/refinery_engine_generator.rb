require 'rails/generators/migration'

class RefineryEngineGenerator < Rails::Generators::NamedBase

  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

  def generate
    unless attributes.empty?
      Dir.glob(File.expand_path('../templates/**/**', __FILE__), File::FNM_DOTMATCH).each do |path|
        # ignore directories which are created automatically by template()
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
        puts "rails generate refinerycms_#{plural_name}"
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
  end

end
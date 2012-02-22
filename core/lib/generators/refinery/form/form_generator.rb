require 'rails/generators/migration'
require 'fileutils'

module Refinery
  class FormGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

    def description
      "Generates an engine which is set up for frontend form submissions like a contact page."
    end

    def generate
      unless attributes.empty? or plural_name =~ /\:/
        Dir.glob(File.expand_path('../templates/**/**', __FILE__), File::FNM_DOTMATCH).reject{|f|
          File.directory?(f)
        }.each do |path|
          unless (engine_path = engine_path_for(path)).nil?
            template path, engine_path
          end
        end

        # Update the gem file
        unless self.behavior == :revoke
          unless Rails.env.test?
            Rails.root.join('Gemfile').open('a') do |f|
              f.write "\ngem 'refinerycms-#{plural_name}', '1.0', :path => 'vendor/engines'"
            end

            puts "------------------------"
            puts "Now run:"
            puts "bundle install"
            puts "rails generate refinery:#{plural_name}"
            puts "rake db:migrate"
            puts "rake db:seed"
            puts "------------------------"
          end
        else
          lines = Rails.root.join('Gemfile').open('r').read.split("\n")
          Rails.root.join('Gemfile').open('w').puts(lines.reject {|l| l =~ %r{refinerycms-#{plural_name}}}.join("\n"))
          if (dir = Rails.root.join('vendor', 'engines', "#{plural_name}")).directory?
            dir.rmtree
            puts "Removed directory #{dir}"
          end
        end
      else
        puts "You must specify a name and at least one field. For help: rails generate refinery_form"
      end
    end

  protected

    def engine_path_for(path)
      engine_path = "vendor/engines/#{plural_name}/"
      path = path.gsub(File.dirname(__FILE__) + "/templates/", engine_path)

      path = path.gsub("plural_name", plural_name)
      path = path.gsub("singular_name", singular_name)

      path
    end

  end
end

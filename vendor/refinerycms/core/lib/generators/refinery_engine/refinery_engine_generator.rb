require 'rails/generators/migration'
require 'yaml'
require 'pathname'

class RefineryEngineGenerator < Rails::Generators::NamedBase

  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

  def generate
    unless attributes.empty?
      if (engine = attributes.detect{|a| a.type.to_s == 'engine'}).present? and attributes.reject!{|a| a.type.to_s == 'engine'}.present?
        engine = engine.name.pluralize
      end

      Dir.glob(File.expand_path('../templates/**/**', __FILE__), File::FNM_DOTMATCH).reject{|f|
        File.directory?(f)
      }.each do |path|
        template path, engine_path_for(path, engine)
      end

      if engine.present?
        # go through all of the temporary yml files and merge them into the current translation files.
        tmp_yml_directory = nil
        Dir.glob(File.expand_path('../templates/config/locales/*.yml', __FILE__), File::FNM_DOTMATCH).each do |path|
          # get the path to the current tmp file.
          path = Rails.root.join(engine_path_for(path, engine))
          tmp_yml_directory = Pathname.new(path.to_s.split(File::SEPARATOR)[0..-2].join(File::SEPARATOR)) # save for later

          # get the path to the existing file and perform a deep hash merge.
          current_yml_path = Pathname.new(path.to_s.split(File::SEPARATOR).reject{|f| f == 'tmp'}.join(File::SEPARATOR))
          yml = YAML::load(path.read).deep_merge(YAML::load(current_yml_path.read))

          # write to current file the merged results.
          current_yml_path.open('w+') { |f| f.puts yml.to_yaml }
        end

        # remove the tmp directory unless we don't have one.
        tmp_yml_directory.rmtree unless tmp_yml_directory.nil?
      end

      # Update the gem file
      unless self.behavior == :revoke
        unless Rails.env.test?
          Rails.root.join('Gemfile').open('a') do |f|
            f.write "\ngem 'refinerycms-#{plural_name}', '1.0', :path => 'vendor/engines', :require => '#{plural_name}'"
          end unless engine.present?

          puts "------------------------"
          puts "Now run:"
          puts "bundle install"
          puts "rails generate refinerycms_#{plural_name}#{" #{engine}" if engine.present?}"
          puts "rake db:migrate"
          puts "------------------------"
        end
      else
        lines = Rails.root.join('Gemfile').open('r').read.split("\n")
        Rails.root.join('Gemfile').open('w').puts(lines.reject {|l| l =~ %r{refinerycms-#{plural_name}}}.join("\n"))
      end
    else
      puts "You must specify at least one field. For help: rails generate refinery_engine"
    end
  end

protected

  def engine_path_for(path, engine)
    engine_path = "vendor/engines/#{engine.present? ? engine : plural_name}/"
    path = path.gsub(File.dirname(__FILE__) + "/templates/", engine_path)

    path = path.gsub("plural_name", plural_name)
    path = path.gsub("singular_name", singular_name)

    # detect whether it's a translation and a file for that translation already exists
    if engine.present? and path =~ %r{/locales/.*\.yml$} and File.exist?(path)
      # put new translations into a tmp directory
      # file doesn't conflict or new engine.
      path = path.split(File::SEPARATOR).insert(-2, "tmp").join(File::SEPARATOR)
    end

    path
  end

end

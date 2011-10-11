require 'pathname'

module Refinery
  module Generators
    class TestingGenerator < ::Refinery::Generators::EngineInstaller

      source_root File.expand_path('../', __FILE__)
      engine_name "testing"

      def generate
        # Render and copy templates
        Pathname.glob(templates_path.join("**", "**")).reject{|f| f.directory?}.each do |src_path|
          template src_path, destination_path.join(src_path.relative_path_from(templates_path))
        end

        # Copy files
        Pathname.glob(files_path.join("**", "**")).reject{|f| f.directory?}.each do |src_path|
          copy_file src_path, destination_path.join(src_path.relative_path_from(files_path))
        end
      end

      def dummy_app
        self.silence_puts = true

        # Run Refinery generators to build dummy app
        dummy_app_destination = destination_path.join("spec", "dummy")
        [
          Refinery::BaseGenerator,
          Refinery::AuthenticationGenerator,
          Refinery::SettingsGenerator,
          Refinery::ResourcesGenerator,
          Refinery::PagesGenerator,
          Refinery::ImagesGenerator,
          Refinery::CmsGenerator
        ].each do |klass|
          klass.send(:new, [], { :force => true }, :destination_root => dummy_app_destination).generate
        end
      end

      private

      # Return destination application's name from it's gemfile
      def gem_name
        return @gem_name if @gem_name
        gemspec_file = Pathname.glob(destination_path.join("*.gemspec")).first
        gemspec = File.read(gemspec_file)
        @gem_name = eval(gemspec).name
      end

      def templates_path
        Pathname.new(self.class.source_root).join("templates")
      end

      def files_path
        Pathname.new(self.class.source_root).join("files")
      end
    end
  end
end

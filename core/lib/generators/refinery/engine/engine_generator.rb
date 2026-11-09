require 'refinery/extension_generation'
require 'refinery/generators/named_base'
require 'refinery/generators/generated_attribute'

module Refinery
  class EngineGenerator < Refinery::Generators::NamedBase
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    include Refinery::ExtensionGeneration

    class_option :skip_frontend,
                 :desc => 'Generate extension without frontend',
                 :type => :boolean,
                 :default => false,
                 :required => false

    def skip_frontend?
      options[:skip_frontend]
    end

    def generate
      default_generate!
    end

    def backend_route
      @backend_route ||= if namespacing.underscore != plural_name
        %Q{"#\{Refinery::Core.backend_route\}/#{namespacing.underscore}"}
      else
        "Refinery::Core.backend_route"
      end
    end

    protected

    def generator_command
      'rails generate refinery:engine'
    end

    def reject_file?(file)
      (skip_frontend? && in_frontend_directory?(file)) || super
    end

    # Match against the path inside the templates directory only, so an "app"
    # elsewhere in the absolute path (e.g. ~/apps or /app in a container)
    # doesn't mark every template as frontend.
    def in_frontend_directory?(file)
      path = Pathname.new(file).relative_path_from(source_pathname).to_s
      path.start_with?('app/') && !path.match?(/admin|models|mailers/)
    end

  end
end

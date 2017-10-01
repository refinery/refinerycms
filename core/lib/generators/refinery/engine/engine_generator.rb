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

    def in_frontend_directory?(file)
      file.to_s.include?('app') && file.to_s.scan(/admin|models|mailers/).empty?
    end
  end
end

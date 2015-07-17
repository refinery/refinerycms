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

    class_option :live_editor,
                 :desc => 'Edit items from the frontend show view: real WYSIWYG',
                 :type => :boolean,
                 :default => false,
                 :required => false

    def include_live_editor?
      options[:live_editor]
    end

    class_option :include_form,
                 :desc => 'Include a form for end users to submit on the frontend of the site',
                 :type => :boolean,
                 :default => false,
                 :required => false

    def include_form?
      options[:include_form]
    end

    class_option :include_moderation,
                 :desc => 'Include a process for approving and rejecting form submissions',
                 :type => :boolean,
                 :default => false,
                 :required => false

    def include_moderation?
      options[:include_moderation]
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

    def reject_file_with_extra_checks?(file)
      puts file.to_s

      if (skip_frontend? && (file.to_s.include?('app') && file.to_s.scan(/admin|models|mailers/).empty?))
        return true
      end

      if (!include_form? && (
        file.to_s.scan(/views\/refinery\/namespace\/admin\/plural_name\/show|views\/refinery\/namespace\/plural_name\/new|mailer|models\/refinery\/namespace\/setting|controllers\/refinery\/namespace\/admin\/settings_controller|views\/refinery\/namespace\/admin\/settings|views\/refinery\/namespace\/mailer/).present?
        ))
        return true
      end

      if include_form? && file.to_s.scan(/views\/refinery\/namespace\/plural_name\/show|views\/refinery\/namespace\/plural_name\/index/).present?
        return true
      end

      if !include_moderation? && (file.to_s.scan(/views\/refinery\/namespace\/admin\/plural_name\/spam/).present?)
        return true
      end

      return reject_file_without_extra_checks?(file)
    end
    alias_method_chain :reject_file?, :extra_checks
  end
end

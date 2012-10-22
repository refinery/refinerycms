require 'rails/generators/named_base'
require 'refinery/extension_generation'

module Refinery
  class EngineGenerator < Rails::Generators::NamedBase
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
      sanity_check!

      evaluate_templates!

      unless options[:pretend]
        merge_locales!

        copy_or_merge_seeds!

        append_extension_to_gemfile!
      end

      finalize_extension!
    end

  protected

    def generator_command
      'rails generate refinery:engine'
    end

    def reject_file_with_skip_frontend?(file)
      (skip_frontend? && (file.to_s.include?('app') && file.to_s.scan(/admin|models|mailers/).empty?)) ||
        reject_file_without_skip_frontend?(file)
    end
    alias_method_chain :reject_file?, :skip_frontend
  end
end

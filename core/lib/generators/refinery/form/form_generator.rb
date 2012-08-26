require 'refinery/extension_generation'
require 'rails/generators/migration'

module Refinery
  class FormGenerator < Rails::Generators::NamedBase
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    include Refinery::ExtensionGeneration

    def description
      "Generates an extension which is set up for frontend form submissions like a contact page."
    end

    def generate
      sanity_check!

      evaluate_templates!

      merge_locales!

      copy_or_merge_seeds!

      append_extension_to_gemfile!

      finalize_extension!
    end

    protected

    def generator_command
      'rails generate refinery:form'
    end

  end
end

require 'refinery/extension_generation'
require 'rails/generators/migration'

module Refinery
  class FormGenerator < Rails::Generators::NamedBase
    source_root Pathname.new(File.expand_path('../templates', __FILE__))

    include Refinery::ExtensionGeneration

    class_option :include_spam,
      :desc => 'Generate extension with spam filtering',
      :type => :boolean,
      :default => false,
      :required => false

    def include_spam?
      options[:include_spam]
    end

    def description
      "Generates an extension which is set up for frontend form submissions like a contact page."
    end

    def generate
      default_generate!
    end

    protected

    def generator_command
      'rails generate refinery:form'
    end

  end
end

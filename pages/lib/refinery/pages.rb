require 'refinerycms-core'
require 'awesome_nested_set'
require 'globalize3'
require 'friendly_id'
require 'seo_meta'

module Refinery
  module Pages
    require 'refinery/pages/engine' if defined?(Rails)
    require 'refinery/generators/pages_generator'

    autoload :InstanceMethods, 'refinery/pages/instance_methods'

    DEFAULT_PAGES_PER_DIALOG = 14
    DEFAULT_PAGES_PER_ADMIN_INDEX = 20

    mattr_accessor :pages_per_dialog
    self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG

    mattr_accessor :pages_per_admin_index
    self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX

    class << self
      # Configure the options of Refinery::Pages.
      #
      #   Refinery::Pages.configure do |config|
      #     config.pages_per_dialog = 27
      #   end
      #
      def configure(&block)
        yield Refinery::Pages
      end

      # Reset Refinery::Pages options to their default values
      #
      def reset!
        self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
        self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def use_marketable_urls?
        ::Refinery::Setting.find_or_set(:use_marketable_urls, true, :scoping => 'pages')
      end

      def use_marketable_urls=(value)
        ::Refinery::Setting.set(:use_marketable_urls, :value => value, :scoping => 'pages')
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end

    module Admin
      autoload :InstanceMethods, 'refinery/pages/admin/instance_methods'
    end
  end
end

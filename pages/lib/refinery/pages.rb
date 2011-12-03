require 'refinerycms-core'
require 'awesome_nested_set'
require 'globalize3'
require 'friendly_id'
require 'seo_meta'

module Refinery
  autoload :PagesGenerator, 'generators/refinery/pages/pages_generator'

  module Pages
    require 'refinery/pages/engine' if defined?(Rails)
    require 'refinery/pages/tab'

    autoload :InstanceMethods, 'refinery/pages/instance_methods'

    include ActiveSupport::Configurable

    # Define configurable settings along with their default values.
    (DEFAULTS = {
      :pages_per_dialog => 14,
      :pages_per_admin_index => 20,
      :new_page_parts => false,
      :marketable_urls => true
    }).each { |name, value| config_accessor name } unless defined?(DEFAULTS)

    class << self
      # Reset Refinery::Pages options to their default values
      def reset!
        DEFAULTS.each do |name, value|
          self.send :"#{name}=", value
        end
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end

    reset!

    module Admin
      autoload :InstanceMethods, 'refinery/pages/admin/instance_methods'
    end
  end
end

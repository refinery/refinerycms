require 'dragonfly'
require 'rack/cache'
require 'refinerycms-core'
require File.expand_path('../generators/resources_generator', __FILE__)

module Refinery
  module Resources

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    autoload :Dragonfly, File.expand_path('../refinery/resources/dragonfly', __FILE__)
    autoload :Validators, 'refinery/resources/validators'

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      initializer 'resources-with-dragonfly', :before => :load_config_initializers do |app|
        ::Refinery::Resources::Dragonfly.setup!
        ::Refinery::Resources::Dragonfly.attach!(app)
      end
      
      initializer 'resources-configuration', :before => :load_config_initializers do |app|
        configure!
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_files'
          plugin.url = app.routes.url_helpers.refinery_admin_resources_path
          plugin.menu_match = /refinery\/(refinery_)?(files|resources)$/
          plugin.version = %q{2.0.0}
          plugin.activity = {
            :class => ::Refinery::Resource
          }
        end
      end
      
      private
        def defaults
          { 
            'max_client_body_size' => 52428800
          }
        end
        
        def resources_config
          config = {}
          begin
            config = YAML.load_file(File.join(Rails.root, 'config', 'refinery', 'resources.yml'))[Rails.env]
          rescue; end
          defaults.merge(config)
        end
        
        def configure!
          ::Refinery::Resource.max_client_body_size = resources_config['max_client_body_size']
        end
    end
  end
end

::Refinery.engines << 'resources'

require 'dragonfly'
require 'rack/cache'
require 'refinerycms-core'
require File.expand_path('../generators/resources_generator', __FILE__)

module Refinery
  module Resources
    
    mattr_accessor :max_client_body_size

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
      
      def configure!
        Resources.max_client_body_size = config['max_client_body_size']
      end
      
      def config
        config = {}
        begin
          config = YAML.load_file(File.join(Rails.root, 'config', 'refinery', 'resources.yml'))[Rails.env]
        rescue; end
        defaults.merge(config)
      end
      
      protected
        def defaults
          { 
            'max_client_body_size' => 52428800
          }
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
      
      initializer 'resources-configuration' do |app|
        ::Refinery::Resources.configure!
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
    end
  end
end

::Refinery.engines << 'resources'

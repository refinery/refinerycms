require 'dragonfly'
require 'rack/cache'
require 'refinerycms-core'
require File.expand_path('../generators/resources_generator', __FILE__)

module Refinery
  module Resources
    autoload :Dragonfly, 'refinery/resources/dragonfly'
    autoload :Validators, 'refinery/resources/validators'
    autoload :Engine, 'refinery/resources/engine'
    
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
  end
end

::Refinery.engines << 'resources'

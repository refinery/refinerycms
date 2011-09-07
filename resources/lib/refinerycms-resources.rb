require 'dragonfly'
require 'rack/cache'
require 'refinerycms-core'
require File.expand_path('../generators/resources_generator', __FILE__)

module Refinery
  module Resources
    autoload :Dragonfly, 'refinery/resources/dragonfly'
    autoload :Validators, 'refinery/resources/validators'
    
    module Config
      mattr_accessor :max_file_size
    end

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
      
      def configure!
        Config.max_file_size = config['max_file_size']
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
            'max_file_size' => 52428800
          }
        end
    end
  end
end

require 'refinery/resources/engine'
::Refinery.engines << 'resources'

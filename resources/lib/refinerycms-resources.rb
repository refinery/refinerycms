require 'refinerycms-core'
require 'dragonfly'
require 'rack/cache'

module Refinery
  module Resources
    require 'refinery/resources/engine' if defined?(Rails)
    require 'refinery/generators/resources_generator'

    autoload :Dragonfly, 'refinery/resources/dragonfly'
    autoload :Validators, 'refinery/resources/validators'
    autoload :Options, 'refinery/resources/options'

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ File.expand_path("../../spec/factories", __FILE__) ]
      end
    end
  end
end

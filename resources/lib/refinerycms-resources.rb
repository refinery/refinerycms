require 'dragonfly'
require 'rack/cache'
require 'refinerycms-core'
require File.expand_path('../generators/resources_generator', __FILE__)

module Refinery
  module Resources
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

require 'refinery/resources/engine'
::Refinery.engines << 'resources'

require 'dragonfly'
require 'rack/cache'
require 'refinerycms-core'
require File.expand_path('../generators/images_generator', __FILE__)

module Refinery
  module Images
    autoload :Dragonfly, 'refinery/images/dragonfly'
    autoload :Validators, 'refinery/images/validators'
    autoload :Options, 'refinery/images/options'

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

require 'refinery/images/engine'
::Refinery.engines << 'images'

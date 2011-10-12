require 'refinerycms-core'
require 'dragonfly'
require 'rack/cache'

module Refinery
  module Images
    require 'refinery/images/engine' if defined?(Rails)
    require 'refinery/generators/images_generator'

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

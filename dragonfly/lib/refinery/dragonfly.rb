require 'active_support/configurable'
require 'dragonfly'

module Refinery
  autoload :DragonflyGenerator, 'generators/refinery/dragonfly/dragonfly_generator'

  module Dragonfly
    require 'refinery/dragonfly/configuration'
    require 'refinery/dragonfly/dragonfly'
    require 'refinery/dragonfly/engine'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end

  end
end

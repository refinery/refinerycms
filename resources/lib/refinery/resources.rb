require 'refinerycms-core'
require 'dragonfly'

module Refinery
  autoload :ResourcesGenerator, 'generators/refinery/resources/resources_generator'

  module Resources
    require 'refinery/resources/engine'
    require 'refinery/resources/configuration'

    autoload :Dragonfly, 'refinery/resources/dragonfly'
    autoload :Validators, 'refinery/resources/validators'

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

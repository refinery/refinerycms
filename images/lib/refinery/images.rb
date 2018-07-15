require 'refinerycms-core'
require 'refinerycms-dragonfly'

module Refinery
  autoload :ImagesGenerator, 'generators/refinery/images/images_generator'

  module Images
    require 'refinery/images/engine'
    require 'refinery/dragonfly/extension_configuration'
    require 'refinery/images/configuration'

    autoload :Validators, 'refinery/images/validators'

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

ActiveSupport.on_load(:active_record) do
  require 'mobility'
end

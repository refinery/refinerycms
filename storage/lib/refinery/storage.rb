require 'active_support/configurable'
require 'shrine'

module Refinery
  autoload :StorageGenerator, 'generators/refinery/storage/storage_generator'

  module Storage
    require 'refinery/storage/configuration'
    require 'refinery/storage/storage'
    require 'refinery/storage/engine'

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

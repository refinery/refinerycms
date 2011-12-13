require 'refinerycms-core'
require 'dragonfly'
require 'rack/cache'

module Refinery
  autoload :ResourcesGenerator, 'generators/refinery/resources/resources_generator'

  module Resources
    require 'refinery/resources/engine' if defined?(Rails)

    autoload :Dragonfly, 'refinery/resources/dragonfly'
    autoload :Validators, 'refinery/resources/validators'

    include ActiveSupport::Configurable

    config_accessor :dragonfly_insert_before, :max_file_size, :pages_per_dialog, :pages_per_admin_index

    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.max_file_size = 52428800
    self.pages_per_dialog = 12
    self.pages_per_admin_index = 20

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

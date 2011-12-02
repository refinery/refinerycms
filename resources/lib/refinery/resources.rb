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

    config_accessor :max_file_size, :pages_per_dialog, :pages_per_admin_index

    DEFAULT_MAX_FILE_SIZE = 52428800
    DEFAULT_PAGES_PER_DIALOG = 12
    DEFAULT_PAGES_PER_ADMIN_INDEX = 20

    self.max_file_size = DEFAULT_MAX_FILE_SIZE
    self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
    self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX

    class << self
      # Reset Refinery::Resources options to their default values
      #
      def reset!
        self.max_file_size = DEFAULT_MAX_FILE_SIZE
        self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
        self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end
  end
end

require 'refinerycms-core'
require 'dragonfly'
require 'rack/cache'

module Refinery
  module Resources
    require 'refinery/resources/engine' if defined?(Rails)
    require 'refinery/generators/resources_generator'

    autoload :Dragonfly, 'refinery/resources/dragonfly'
    autoload :Validators, 'refinery/resources/validators'

    DEFAULT_MAX_FILE_SIZE = 52428800
    DEFAULT_PAGES_PER_DIALOG = 12
    DEFAULT_PAGES_PER_ADMIN_INDEX = 20

    mattr_accessor :max_file_size
    self.max_file_size = DEFAULT_MAX_FILE_SIZE

    mattr_accessor :pages_per_dialog
    self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG

    mattr_accessor :pages_per_admin_index
    self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX

    class << self
      # Configure the options of Refinery::Resources.
      #
      #   Refinery::Resources.configure do |config|
      #     config.max_file_size = 8201984
      #   end
      #
      def configure(&block)
        yield Refinery::Resources
      end

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

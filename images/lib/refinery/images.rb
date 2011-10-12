require 'refinerycms-core'
require 'dragonfly'
require 'rack/cache'

module Refinery
  module Images
    require 'refinery/images/engine' if defined?(Rails)
    require 'refinery/generators/images_generator'

    autoload :Dragonfly, 'refinery/images/dragonfly'
    autoload :Validators, 'refinery/images/validators'

    DEFAULT_MAX_IMAGE_SIZE = 5242880
    DEFAULT_PAGES_PER_DIALOG = 18
    DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS = 12
    DEFAULT_PAGES_PER_ADMIN_INDEX = 20

    mattr_accessor :max_image_size
    self.max_image_size = DEFAULT_MAX_IMAGE_SIZE

    mattr_accessor :pages_per_dialog
    self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG

    mattr_accessor :pages_per_dialog_that_have_size_options
    self.pages_per_dialog_that_have_size_options = DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS

    mattr_accessor :pages_per_admin_index
    self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX

    class << self
      # Configure the options of Refinery::Images.
      #
      #   Refinery::Images.configure do |config|
      #     config.max_image_size = 8201984
      #   end
      #
      def configure(&block)
        yield Refinery::Images
      end

      # Reset Refinery::Images options to their default values
      #
      def reset!
        self.max_image_size = DEFAULT_MAX_IMAGE_SIZE
        self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
        self.pages_per_dialog_that_have_size_options = DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
        self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX
      end

      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end
  end
end

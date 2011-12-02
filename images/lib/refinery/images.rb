require 'refinerycms-core'
require 'dragonfly'
require 'rack/cache'

module Refinery
  autoload :ImagesGenerator, 'generators/refinery/images/images_generator'

  module Images
    require 'refinery/images/engine' if defined?(Rails)

    autoload :Dragonfly, 'refinery/images/dragonfly'
    autoload :Validators, 'refinery/images/validators'

    include ActiveSupport::Configurable

    config_accessor :max_image_size, :pages_per_dialog, :pages_per_admin_index,
                    :pages_per_dialog_that_have_size_options

    DEFAULT_MAX_IMAGE_SIZE = 5242880
    DEFAULT_PAGES_PER_DIALOG = 18
    DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS = 12
    DEFAULT_PAGES_PER_ADMIN_INDEX = 20

    self.max_image_size = DEFAULT_MAX_IMAGE_SIZE
    self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
    self.pages_per_dialog_that_have_size_options = DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
    self.pages_per_admin_index = DEFAULT_PAGES_PER_ADMIN_INDEX

    class << self
      # Reset Refinery::Images options to their default values
      #
      def reset!
        self.max_image_size = DEFAULT_MAX_IMAGE_SIZE
        self.pages_per_dialog = DEFAULT_PAGES_PER_DIALOG
        self.pages_per_dialog_that_have_size_options = DEFAULT_PAGES_PER_DIALOG_THAT_HAVE_SIZE_OPTIONS
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

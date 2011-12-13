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

    config_accessor :dragonfly_insert_before, :max_image_size, :pages_per_dialog, :pages_per_admin_index,
                    :pages_per_dialog_that_have_size_options, :user_image_sizes

    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.max_image_size = 5242880
    self.pages_per_dialog = 18
    self.pages_per_dialog_that_have_size_options = 12
    self.pages_per_admin_index = 20
    self.user_image_sizes = { :small => '110x110>',
                              :medium => '225x255>',
                              :large => '450x450>' }

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

module Refinery
  module Images
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_images

      config.autoload_paths += %W( #{config.root}/lib )

      initializer 'setup-refinery-images-with-dragonfly', :before => :load_config_initializers do |app|
        ::Refinery::Images::Dragonfly.setup!
      end

      initializer 'attach-refinery-images-with-dragonfly', :after => :load_config_initializers do |app|
        ::Refinery::Images::Dragonfly.configure!
        ::Refinery::Images::Dragonfly.attach!(app)
      end

      initializer "register refinery_images plugin", :after => :set_routes_reloader_hook do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_images'
          plugin.directory = 'images'
          plugin.version = %q{2.0.0}
          plugin.menu_match = %r{refinery/image(_dialog)?s$}
          plugin.activity = {
            :class_name => :'refinery/image',
            :url => "refinery_admin_image_path" # temp hack for namespacees
          }
          plugin.url = {:controller => '/refinery/admin/images'}
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Images)
      end
    end
  end
end

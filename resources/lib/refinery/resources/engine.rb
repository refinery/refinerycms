module Refinery
  module Resources
    class Engine < ::Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_resources

      config.autoload_paths += %W( #{config.root}/lib )

      initializer 'attach-refinery-resources-with-dragonfly', :before => :finisher_hook do |app|
        ::Refinery::Dragonfly.configure!(Refinery::Resources)
        ::Refinery::Dragonfly.attach!(app, Refinery::Resources)
      end

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_files'
          plugin.menu_match = /refinery\/(refinery_)?(files|resources)$/
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_resources_path }
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Resources)
      end
    end
  end
end

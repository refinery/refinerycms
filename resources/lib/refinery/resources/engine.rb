module Refinery
  module Resources
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_resources

      config.autoload_paths += %W( #{config.root}/lib )

      initializer 'resources-with-dragonfly', :before => :load_config_initializers do |app|
        ::Refinery::Resources::Dragonfly.setup!
        ::Refinery::Resources::Dragonfly.attach!(app)
      end

      initializer "register refinery_files plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_files'
          plugin.menu_match = /refinery\/(refinery_)?(files|resources)$/
          plugin.version = %q{2.0.0}
          plugin.activity = {
            :class_name => :'refinery/resource'
          }
          plugin.url = { :controller => '/refinery/admin/resources' }
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Resources)
      end
    end
  end
end

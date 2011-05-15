require 'refinerycms-base'

module Refinery
  module Layouts
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "layouts"
          plugin.activity = {
            :class => Layout,
            :title => 'template_name'
          }
        end
      end
    end
  end
end

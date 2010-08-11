require 'rack/cache'
require 'refinery'

module Refinery
  module Resources
    class Engine < Rails::Engine
      initializer 'files-with-dragonfly' do |app|
        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :resources

        app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
          :verbose     => true,
          :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
          :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
        }
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.title = 'Files'
          plugin.name = "refinery_files"
          plugin.url = {:controller => 'admin/resources', :action => 'index'}
          plugin.menu_match = /(refinery|admin)\/(refinery_)?(files|resources)$/
          plugin.description = "Upload and link to files"
          plugin.version = %q{0.9.8}
          plugin.activity = {
            :class => Resource
          }
        end
      end
    end
  end
end

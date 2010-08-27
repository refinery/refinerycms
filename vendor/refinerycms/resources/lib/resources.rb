require 'rack/cache'
require 'dragonfly'
require 'refinery'

module Refinery
  module Resources
    class Engine < Rails::Engine
      initializer 'resources-with-dragonfly' do |app|
        app_resources = Dragonfly::App[:resources]
        app_resources.configure_with(:rails) do |c|
          c.register_analyser(Dragonfly::Analysis::FileCommandAnalyser)
          c.datastore.root_path = "#{::Rails.root}/public/system/resources"
          c.path_prefix = '/system/resources'
          c.secret      = 'SweinkelvyonCaccepla'
          c.protect_from_dos_attacks = false
        end

        app_resources.configure_with(:heroku, ENV['S3_BUCKET']) if Refinery.s3_backend

        ### Extend active record ###
        app_resources.define_macro(ActiveRecord::Base, :resource_accessor)

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

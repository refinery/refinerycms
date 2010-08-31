require 'rack/cache'
require 'dragonfly'
require 'refinery'

module Refinery
  module Resources
    class Engine < Rails::Engine
      initializer 'resources-with-dragonfly' do |app|
        app_resources = Dragonfly[:resources]
        app_resources.configure_with(:rmagick)
        app_resources.configure_with(:rails) do |c|
          c.datastore.root_path = Rails.root.join('public', 'system', 'resources').to_s
          c.url_path_prefix = '/system/resources'
          if RefinerySetting.table_exists?
            c.secret = RefinerySetting.find_or_set(:dragonfly_secret,
                                                   Array.new(24) { rand(256) }.pack('C*').unpack('H*').first)
          end
        end
        app_resources.configure_with(:heroku, ENV['S3_BUCKET']) if Refinery.s3_backend

        app_resources.define_macro(ActiveRecord::Base, :resource_accessor)
        app_resources.analyser.register(Dragonfly::Analysis::FileCommandAnalyser)

        ### Extend active record ###

        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :resources, '/system/resources'

        app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
          :verbose     => true,
          :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
          :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
        }
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_files"
          plugin.url = {:controller => 'admin/resources', :action => 'index'}
          plugin.menu_match = /(refinery|admin)\/(refinery_)?(files|resources)$/
          plugin.version = %q{0.9.8}
          plugin.activity = {
            :class => Resource
          }
        end
      end
    end
  end
end

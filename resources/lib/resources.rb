require 'rack/cache'
require 'dragonfly'
require 'refinery'

module Refinery
  module Resources
    class Engine < Rails::Engine
      initializer 'resources-with-dragonfly' do |app|
        app_resources = Dragonfly[:resources]
        app_resources.configure_with(:rails) do |c|
          c.datastore.root_path = Rails.root.join('public', 'system', 'resources').to_s
          c.url_path_prefix = '/system/resources'
          c.secret = RefinerySetting.find_or_set(:dragonfly_secret,
                                                 Array.new(24) { rand(256) }.pack('C*').unpack('H*').first)
        end
        app_resources.configure_with(:heroku, ENV['S3_BUCKET']) if Refinery.s3_backend

        app_resources.define_macro(ActiveRecord::Base, :resource_accessor)
        app_resources.analyser.register(Dragonfly::Analysis::FileCommandAnalyser)
        app_resources.content_disposition = :attachment   

        # This url_suffix makes it so that dragonfly urls work in traditional
        # situations where the filename and extension are required, e.g. lightbox.
        # What this does is takes the url that is about to be produced e.g.
        # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw
        # and adds the filename onto the end (say the file was 'refinery_is_awesome.pdf')
        # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw/refinery_is_awesome.pdf
        # Officially the way to do it, from: http://markevans.github.com/dragonfly/file.URLs.html
        app_resources.url_suffix = proc{|job|
          object_file_name = job.uid_basename.gsub(%r{^(\d{4}|\d{2})[_/]\d{2}[_/]\d{2}[_/]\d{2,3}[_/](\d{2}/\d{2}/\d{3}/)?}, '')
          "/#{object_file_name}#{job.encoded_extname || job.uid_extname}"
        }

        ### Extend active record ###

        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :resources, '/system/resources'

        app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
          :verbose     => Rails.env.development?,
          :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
          :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
        }
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_files"
          plugin.url = {:controller => '/admin/resources', :action => 'index'}
          plugin.menu_match = /(refinery|admin)\/(refinery_)?(files|resources)$/
          plugin.version = %q{0.9.9}
          plugin.activity = {
            :class => Resource
          }
        end
      end
    end
  end
end

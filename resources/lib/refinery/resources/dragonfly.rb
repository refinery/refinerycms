module Refinery
  module Resources
    module Dragonfly

      class << self
        def setup!
          app_resources = ::Dragonfly[:resources]
          app_resources.configure_with(:rails) do |c|
            c.datastore.root_path = Rails.root.join('public', 'system', 'resources').to_s
            # This url_format makes it so that dragonfly urls work in traditional
            # situations where the filename and extension are required, e.g. lightbox.
            # What this does is takes the url that is about to be produced e.g.
            # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw
            # and adds the filename onto the end (say the file was 'refinery_is_awesome.pdf')
            # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw/refinery_is_awesome.pdf
            c.url_format = '/system/resources/:job/:basename.:format'
            c.secret = ::Refinery::Setting.find_or_set(:dragonfly_secret, Array.new(24) { rand(256) }.pack('C*').unpack('H*').first)
          end

          if ::Refinery.s3_backend
            app_resources.configure_with(:heroku, ENV['S3_BUCKET'])
            # Dragonfly doesn't set the S3 region, so we have to do this manually
            app_resources.datastore.configure do |d|
              d.region = ENV['S3_REGION'] if ENV['S3_REGION'] # defaults to 'us-east-1'
            end
          end

          app_resources.define_macro(::ActiveRecord::Base, :resource_accessor)
          app_resources.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
          app_resources.content_disposition = :attachment
        end

        def attach!(app)
          ### Extend active record ###

          app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :resources

          app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose     => Rails.env.development?,
            :metastore   => "file:#{URI.encode(Rails.root.join('tmp', 'dragonfly', 'cache', 'meta').to_s)}",
            :entitystore => "file:#{URI.encode(Rails.root.join('tmp', 'dragonfly', 'cache', 'body').to_s)}"
          }
        end
      end

    end
  end
end

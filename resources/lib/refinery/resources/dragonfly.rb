module Refinery
  module Resources
    module Dragonfly

      class << self
        def setup!
          app_resources = ::Dragonfly[:refinery_resources]

          app_resources.define_macro(::Refinery::Core::Base, :resource_accessor)

          app_resources.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
          app_resources.content_disposition = :attachment
        end

        def configure!
          app_resources = ::Dragonfly[:refinery_resources]
          app_resources.configure_with(:rails) do |c|
            c.datastore.root_path = Refinery::Resources.datastore_root_path

            # This url_format makes it so that dragonfly urls work in traditional
            # situations where the filename and extension are required, e.g. lightbox.
            # What this does is takes the url that is about to be produced e.g.
            # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw
            # and adds the filename onto the end (say the file was 'refinery_is_awesome.pdf')
            # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw/refinery_is_awesome.pdf
            c.url_format = Refinery::Resources.config.dragonfly_url_format
            c.secret = Refinery::Resources.config.dragonfly_secret
          end

          if ::Refinery::Resources.config.s3_backend
            app_resources.datastore = Dragonfly::DataStore::S3DataStore.new
            app_resources.datastore.configure do |s3|
              s3.bucket_name = Refinery::Resources.config.s3_bucket_name
              s3.access_key_id = Refinery::Resources.config.s3_access_key_id
              s3.secret_access_key = Refinery::Resources.config.s3_secret_access_key
              # S3 Region otherwise defaults to 'us-east-1'
              s3.region = Refinery::Resources.config.s3_region if Refinery::Resources.config.s3_region
            end
          end
        end

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before Refinery::Resources.config.dragonfly_insert_before,
                                              'Dragonfly::Middleware', :refinery_resources

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

require 'dragonfly'

module Refinery
  module Images
    module Dragonfly

      class << self
        def setup!
          app_images = ::Dragonfly[:refinery_images]
          app_images.configure_with(:imagemagick)

          app_images.define_macro(::Refinery::Image, :image_accessor)

          app_images.analyser.register(::Dragonfly::ImageMagick::Analyser)
          app_images.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
        end

        def configure!
          app_images = ::Dragonfly[:refinery_images]
          app_images.configure_with(:rails) do |c|
            c.datastore.root_path = Refinery::Images.datastore_root_path
            c.url_format = Refinery::Images.dragonfly_url_format
            c.secret = Refinery::Images.dragonfly_secret
            c.trust_file_extensions = Refinery::Images.trust_file_extensions
          end

          if ::Refinery::Images.s3_backend
            app_images.datastore = ::Dragonfly::DataStorage::S3DataStore.new
            app_images.datastore.configure do |s3|
              s3.bucket_name = Refinery::Images.s3_bucket_name
              s3.access_key_id = Refinery::Images.s3_access_key_id
              s3.secret_access_key = Refinery::Images.s3_secret_access_key
              # S3 Region otherwise defaults to 'us-east-1'
              s3.region = Refinery::Images.s3_region if Refinery::Images.s3_region
            end
            app_images.configure do |c|
              c.server.before_serve do |job, env|
                uid = job.store
                ::Refinery::Images::Thumb.create!( :uid => uid, :job => job.serialize )
              end
              c.define_url do |app, job, opts|
                thumb = ::Refinery::Images::Thumb.find_by_job(job.serialize)
                if thumb
                  app.datastore.url_for(thumb.uid)
                else
                  app.server.url_for(job)
                end
              end
            end
          end
        end

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before Refinery::Images.dragonfly_insert_before,
                                              'Dragonfly::Middleware', :refinery_images

          app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose     => Rails.env.development?,
            :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
            :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
          }
        end
      end
    end
  end
end

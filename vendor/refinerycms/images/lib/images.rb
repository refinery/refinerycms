require 'rack/cache'
require 'dragonfly'
require 'refinery'

module Refinery
  module Images
    class Engine < Rails::Engine
      initializer 'images-with-dragonfly' do |app|
        app_images = Dragonfly[:images]
        app_images.configure_with(:rmagick)
        app_images.configure_with(:rails) do |c|
          c.datastore.root_path = Rails.root.join('public', 'system', 'images').to_s
          c.url_path_prefix = '/system/images'
          if RefinerySetting.table_exists?
            c.secret = RefinerySetting.find_or_set(:dragonfly_secret,
                                                   Array.new(24) { rand(256) }.pack('C*').unpack('H*').first)
          end
        end
        app_images.configure_with(:heroku, ENV['S3_BUCKET']) if Refinery.s3_backend

        app_images.define_macro(ActiveRecord::Base, :image_accessor)
        app_images.analyser.register(Dragonfly::Analysis::RMagickAnalyser)
        app_images.analyser.register(Dragonfly::Analysis::FileCommandAnalyser)

        app_images.instance_eval %{
          def url_for(job, *args)
            image_url = nil
            if (fetcher = job.steps.detect{|s| s.class.step_name == :fetch}).present?
              image_url = ['', fetcher.uid.to_s.split('/').last].join('/')
            end
            "\#{super}\#{image_url}"
          end
        }

        ### Extend active record ###

        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images, '/system/images'

        app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
          :verbose     => true,
          :metastore   => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
          :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
        }
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_images"
          plugin.directory = "images"
          plugin.version = %q{0.9.8}
          plugin.menu_match = /(refinery|admin)\/image(_dialog)?s$/
          plugin.activity = {
            :class => Image
          }
        end
      end
    end
  end
end

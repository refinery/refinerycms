namespace :refinery do
  namespace :testing do
    desc "Generates a dummy app for testing"
    task :dummy_app => [:setup_dummy_app, :migrate_dummy_app]

    task :setup_dummy_app do
      require 'refinerycms'

      params = []
      params << "--database=#{ENV['DB']}" if ENV['DB']
      params << "--quiet"

      Refinery::DummyGenerator.start params

      # Load generated dummy app after generation - some of the follow
      # generators depend on Rails.root being available
      # load File.join(ENGINE_PATH, 'spec/dummy/config/environment.rb')

      Refinery::CmsGenerator.start ['--quiet']
      Refinery::CoreGenerator.start ['--quiet']
      Refinery::ResourcesGenerator.start ['--quiet']
      Refinery::PagesGenerator.start ['--quiet']
      Refinery::ImagesGenerator.start ['--quiet']
    end

    task :migrate_dummy_app do
      engines = [
        'refinery_core',
        'refinery_settings',
        'refinery_authentication',
        'seo_meta_engine',
        'refinery_pages',
        'refinery_images',
        'refinery_resources'
      ]
      system %Q{ bundle exec rake -f #{File.join(Refinery::Testing::Railtie.target_engine_path, 'Rakefile')} app:railties:install:migrations FROM="#{engines.join(', ')}" app:db:drop app:db:create app:db:migrate app:db:seed app:db:test:prepare RAILS_ENV=development --quiet }
    end

    desc "Remove the dummy app used for testing"
    task :clean_dummy_app do
      system "rm -Rdf #{File.join(Refinery::Testing::Railtie.target_engine_path, 'spec/dummy')}"
    end

    namespace :engine do
      desc "Initialize the testing environment"
      task :setup => [:init_test_database]

      task :init_test_database => [
        'app:db:migrate',
        'app:db:test:prepare'
      ]
    end
  end
end

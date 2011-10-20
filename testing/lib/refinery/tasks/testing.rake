namespace :refinery do  
  namespace :testing do
    desc "Generates a dummy app for testing"
    task :dummy_app do
      require "refinerycms"

      params = []
      params << "--database=#{ENV['DB_NAME']}" if ENV['DB_NAME']

      Refinery::DummyGenerator.start params
      
      # Load generated dummy app after generation - some of the follow
      # generators depend on Rails.root being available
      load Refinery.root.join('spec/dummy/config/environment.rb')
      
      Refinery::CmsGenerator.start
      Refinery::CoreGenerator.start
      Refinery::AuthenticationGenerator.start
      Refinery::SettingsGenerator.start
      Refinery::ResourcesGenerator.start
      Refinery::PagesGenerator.start
      Refinery::ImagesGenerator.start
      
      system "bundle exec rake -f #{Refinery.root.join('Rakefile')} app:db:drop app:db:create app:db:migrate app:db:seed app:db:test:prepare RAILS_ENV=development"
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

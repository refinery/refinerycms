namespace :refinery do
  namespace :testing do
    desc "Generates a dummy application for testing, if one doesn't exist."
    task :dummy_app => [
      :report_dummy_app_status,
      :create_dummy_app
    ]

    desc "Creates a dummy application for testing"
    task :create_dummy_app => [
      :setup_dummy_app,
      :setup_extension,
      :init_test_database
    ]

    desc "raises if there is already a dummy application"
    task :report_dummy_app_status do
      raise "\nPlease rm -rf '#{dummy_app_path}'\n\n" if dummy_app_path.exist?
    end

    desc "Sets up just the dummy application for testing, no migrations or extensions"
    task :setup_dummy_app do
      require 'refinerycms-core'

      Refinery::DummyGenerator.start %W[--quiet --database=#{ENV['DB'].presence || 'sqlite3'}]

      Refinery::CmsGenerator.start %w[--quiet --fresh-installation]

      Dir.chdir dummy_app_path
    end

    # This task is a hook to allow extensions to pass configuration
    # Just define this inside your extension's Rakefile or a .rake file
    # and pass arbitrary code. Example:
    #
    # namespace :refinery do
    #   namespace :testing do
    #     task :setup_extension do
    #       require 'refinerycms-my-extension'
    #       Refinery::MyEngineGenerator.start %w[--quiet]
    #     end
    #   end
    # end
    task :setup_extension do
    end

    desc "Remove the dummy app used for testing"
    task :clean_dummy_app => [:drop_dummy_app_database] do
      dummy_app_path.rmtree if dummy_app_path.exist?
    end

    desc "Remove the dummy app's database."
    task :drop_dummy_app_database do
      system "bundle exec rake -f #{File.join(dummy_app_path, 'Rakefile')} db:drop"
    end

    task :init_test_database do
      system "RAILS_ENV=test bundle exec rake -f #{File.join(dummy_app_path, 'Rakefile')} db:create db:migrate"
    end

    def dummy_app_path
      Refinery::Testing::Railtie.target_extension_path.join('spec', 'dummy')
    end
  end
end

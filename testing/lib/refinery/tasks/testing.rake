namespace :refinery do
  namespace :testing do
    desc "Generates a dummy app for testing"
    task :dummy_app do
      unless dummy_app_path.exist?
        Rake::Task["refinery:testing:setup_dummy_app"].invoke
        Rake::Task["refinery:testing:setup_extension"].invoke
        Rake::Task["refinery:testing:init_test_database"].invoke
      end
    end

    task :setup_dummy_app do
      require 'refinerycms'

      params = %w(--quiet)
      params << "--database=#{ENV['DB']}" if ENV['DB']

      Refinery::DummyGenerator.start params

      # Ensure the database is not there from a previous run.
      Rake::Task['refinery:testing:drop_dummy_app_database'].invoke

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
    task :clean_dummy_app do
      Rake::Task['refinery:testing:drop_dummy_app_database'].invoke
      dummy_app_path.rmtree if dummy_app_path.exist?
    end

    desc "Remove the dummy app's database."
    task :drop_dummy_app_database do
      system "bundle exec rake -f #{File.join(dummy_app_path, 'Rakefile')} db:drop"
    end

    task :init_test_database do
      system "bundle exec rake -f #{File.join(dummy_app_path, 'Rakefile')} db:test:prepare"
    end

    def dummy_app_path
      Refinery::Testing::Railtie.target_extension_path.join('spec', 'dummy')
    end
  end
end

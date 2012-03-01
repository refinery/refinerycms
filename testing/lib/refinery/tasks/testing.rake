namespace :refinery do
  namespace :testing do
    desc "Generates a dummy app for testing"
    task :dummy_app => [:setup_dummy_app, :setup_extension, "extension:setup"]

    task :setup_dummy_app do
      require 'refinerycms'

      params = %w(--quiet)
      params << "--database=#{ENV['DB']}" if ENV['DB']

      Refinery::DummyGenerator.start params

      Refinery::CmsGenerator.start %w[--quiet --fresh-installation]
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
      path = Refinery::Testing::Railtie.target_extension_path.join('spec', 'dummy')

      path.rmtree if path.exist?
    end

    namespace :extension do
      desc "Initialize the testing environment"
      task :setup => [:init_test_database]

      task :init_test_database do
        task_params = [%Q{ bundle exec rake -f #{Refinery::Testing::Railtie.target_extension_path.join('Rakefile')} }]
        task_params << %Q{ app:db:test:prepare }

        system task_params.join(' ')
      end
    end
  end
end

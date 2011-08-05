require 'refinery/testing/task_helpers'
extend Refinery::Testing::TaskHelpers

namespace :refinery do  
  namespace :testing do
    namespace :engine do
      desc "Initialize the testing environment"
      task :setup => [
        :init_dummy_app,
        :init_test_database
      ]

      task :init_dummy_app do
        unless submodule_exists?("spec/dummy")
          submodule_path = File.join(ENGINE_PATH, "spec", "dummy")
          system "git submodule add #{DUMMY_APP_GIT_URL} #{submodule_path}"
        end
        
        system "git submodule init"
        system "git submodule update"
      end

      task :init_test_database => [
        'app:db:migrate',
        'app:db:test:prepare'
      ]
    end
  end
end

namespace :refinery do  
  namespace :testing do
    
    desc "Initialize the testing environment"
    task :setup => [
      :init_dummy_app,
      :init_test_database
    ]
    
    task :init_dummy_app do
      system "git submodule init"
      system "git submodule update"
    end
    
    task :init_test_database => [
      'app:db:migrate',
      'app:db:test:prepare'
    ]
   
  end
end

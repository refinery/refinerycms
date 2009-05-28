namespace :db do
  
  desc "Load database with initial data"
  task :setup => :environment do
    seed_file = File.join(Rails.root, 'db', 'seeds.rb')
    load(seed_file) if File.exists?(seed_file)	
  end

end

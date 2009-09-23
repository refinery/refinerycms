namespace :refinery do

  desc "Prepare a basic environment with blank directories ready to override core files safely."
  task :override => :environment do
    dirs = ["app", "app/views", "app/views/layouts", "app/views/admin", "app/views/shared", "app/controllers", "app/models", "app/controllers/admin", "app/helpers", "app/helpers/admin"]
		dirs.each do |dir|
			dir = File.join([RAILS_ROOT] | dir.split('/'))
			Dir.mkdir dir unless File.directory? dir
		end
  end
  
end
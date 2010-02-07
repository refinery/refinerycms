namespace :refinery do

  desc "Prepare a basic environment with blank directories ready to override core files safely."
  task :override => :environment do
    dirs = ["app", "app/views", "app/views/layouts", "app/views/admin", "app/views/shared", "app/controllers", "app/models", "app/controllers/admin", "app/helpers", "app/helpers/admin"]
		dirs.each do |dir|
			dir = Rails.root.join(dir.split('/').join(File::SEPARATOR))
			dir.mkdir unless dir.directory?
		end
  end

  desc "Required to upgrade from <= 0.9.0 to 0.9.1 and above"
  task :fix_image_paths_in_content => :environment do
    Page.all.each do |p|
      p.parts.each do |pp|
        pp.update_attribute(:body, pp.body.gsub(/\/images\/system\//, "/system/images/"))
      end
    end

    NewsItem.all.each do |ni|
      ni.update_attribute(:body, ni.body.gsub(/\/images\/system\//, "/system/images/"))
    end

  end

  namespace :cache do
    desc "Eliminate existing cache files for javascript and stylesheet resources in default directories"
    task :clear => :environment do
      FileUtils.rm(Dir[Rails.root.join("public", "javascripts", "cache", "[^.]*")])
      FileUtils.rm(Dir[Rails.root.join("public", "stylesheets", "cache", "[^.]*")])
    end
  end

end
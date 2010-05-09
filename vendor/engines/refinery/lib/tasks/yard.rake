begin
	
  require 'yard'

	YARD::Rake::YardocTask.new do |t|
		t.files   = ['lib/**/*.rb',
							 'lib/*',
							 'app/**/*.rb',
							 'db/seeds.rb',
							 'config/preinitializer.rb',
							 'vendor/engines/images/**/*.rb',
							 'vendor/engines/authentication/**/*.rb',
							 'vendor/engines/dashboard/**/*.rb',
							 'vendor/engines/inquiries/**/*.rb',
							 'vendor/engines/news/**/*.rb',
							 'vendor/engines/pages/**/*.rb',
							 'vendor/engines/refinery/**/*.rb',
							 'vendor/engines/refinery_dialogs/**/*.rb',
							 'vendor/engines/refinery_settings/**/*.rb',
							 'vendor/engines/resources/**/*.rb',
							 'vendor/engines/themes/**/*.rb',
							 '-', 'License', 'Contributors',
							 'vendor/engines/themes/Themes.rdoc']
  end
  
rescue LoadError
	
  task :yard do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end

end
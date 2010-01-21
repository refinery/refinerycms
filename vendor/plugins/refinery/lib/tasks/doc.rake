namespace :doc do
	
	task :app => [:refinery]
	
	desc "Generate documentation for the application"
	Rake::RDocTask.new(:refinery) { |rdoc|
	  rdoc.title    = "Refinery CMS Documentation"
	  rdoc.main = "README.rdoc"
	  rdoc.options = ['--inline-source']
	  rdoc.rdoc_files.include('lib/**/*.rb',
	              						 'lib/*',
	              						 'app/**/*.rb',
	              						 'db/seeds.rb',
	              						 'config/preinitializer.rb',
	              						 'vendor/plugins/images/**/*.rb',
	              						 'vendor/plugins/authentication/**/*.rb',
	              						 'vendor/plugins/dashboard/**/*.rb',
	              						 'vendor/plugins/inquiries/**/*.rb',
	              						 'vendor/plugins/news/**/*.rb',
	              						 'vendor/plugins/pages/**/*.rb',
	              						 'vendor/plugins/refinery/**/*.rb',
	              						 'vendor/plugins/refinery_dialogs/**/*.rb',
	              						 'vendor/plugins/refinery_settings/**/*.rb',
	              						 'vendor/plugins/resources/**/*.rb',
	              						 'vendor/plugins/themes/**/*.rb',
														 'README.rdoc', 'LICENSE', 'CONTRIBUTORS', 'vendor/plugins/themes/themes.rdoc')
	}

end

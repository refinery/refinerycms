namespace :doc do

  task :app => [:refinery]

  desc "Generate documentation for the application"
  Rake::RDocTask.new(:refinery) { |rdoc|
    rdoc.title    = "Refinery CMS Documentation"
    rdoc.main = "readme.md"
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
                             'readme.md', 'license.md', 'vendor/plugins/themes/readme.md')
  }

end

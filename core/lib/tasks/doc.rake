require 'rdoc/task'

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
                             'vendor/engines/images/**/*.rb',
                             'vendor/engines/authentication/**/*.rb',
                             'vendor/engines/dashboard/**/*.rb',
                             'vendor/engines/inquiries/**/*.rb',
                             'vendor/engines/news/**/*.rb',
                             'vendor/engines/pages/**/*.rb',
                             'vendor/engines/refinery/**/*.rb',
                             'vendor/engines/refinery_dialogs/**/*.rb',
                             'vendor/engines/settings/**/*.rb',
                             'vendor/engines/resources/**/*.rb',
                             'vendor/engines/themes/**/*.rb',
                             'readme.md', 'license.md', 'vendor/engines/themes/readme.md')
  }

end

begin

  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb',
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
               '-', 'License',
               'vendor/plugins/themes/Themes.rdoc']
  end

rescue LoadError

  task :yard do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end

end
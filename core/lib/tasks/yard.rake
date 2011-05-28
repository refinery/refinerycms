begin

  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb',
               'lib/*',
               'app/**/*.rb',
               'db/seeds.rb',
               'config/preinitializer.rb',
               'images/**/*.rb',
               'authentication/**/*.rb',
               'dashboard/**/*.rb',
               'inquiries/**/*.rb',
               'news/**/*.rb',
               'pages/**/*.rb',
               'refinery/**/*.rb',
               'refinery_dialogs/**/*.rb',
               'settings/**/*.rb',
               'resources/**/*.rb',
               '-', 'License']
  end

rescue LoadError

  task :yard do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end

end

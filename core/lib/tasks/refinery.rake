namespace :refinery do
  desc "Override files for use in an application"
  task :override => :environment do
    Refinery::Cli.new.override(ENV)
  end

  desc "Override files for use in an application"
  namespace :override do
    task :list => :environment do
      Refinery::Cli.new.override_list(ENV)
    end
  end

  desc "Un-crudify a method on a controller that uses crudify"
  task :uncrudify => :environment do
    Refinery::Cli.new.uncrudify(ENV['controller'], ENV['action'])
  end
end

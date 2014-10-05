namespace :refinery do
  desc "Override files for use in an application"
  task override: :environment do
    Refinery::CLI.new.override(ENV)
  end

  desc "Un-crudify a method on a controller that uses crudify"
  task uncrudify: :environment do
    Refinery::CLI.new.uncrudify(ENV['controller'], ENV['action'])
  end
end

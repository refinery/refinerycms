namespace :refinery do
  desc "Override files for use in an application"
  task :override => :environment do
    Refinery::CLI.new.override(ENV)
  end

  desc "Un-crudify a method on a controller that uses crudify"
  task :uncrudify => :environment do
    Refinery::CLI.new.uncrudify(ENV['controller'], ENV['action'])
  end

end

desc "Recalculate $LOAD_PATH frequencies."
task :recalculate_loaded_features_frequency => :environment do
  require 'refinery/load_path_analyzer'

  frequencies     = LoadPathAnalyzer.new($LOAD_PATH, $LOADED_FEATURES).frequencies
  ideal_load_path = frequencies.to_a.sort_by(&:last).map(&:first)

  Rails.root.join('config', 'ideal_load_path').open("w") do |f|
    f.puts ideal_load_path
  end
end

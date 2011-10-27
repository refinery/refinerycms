ENGINES = %w{ authentication core dashboard images pages resources settings testing }

require File.expand_path('../../core/lib/refinery/version', __FILE__)
version = Refinery::Version.to_s
root = File.expand_path('../../', __FILE__)

(ENGINES + ['refinerycms']).each do |engine|
  namespace engine do
    engine_name = engine
    engine_name = "refinerycms-#{engine}" unless engine == "refinerycms"
    
    gem_filename = "pkg/#{engine_name}-#{version}.gem"
    gemspec = "#{engine_name}.gemspec"
    
    task :clean do
      package_dir = "#{root}/pkg"
      mkdir_p package_dir unless File.exists?(package_dir)
      rm_f gem_filename
    end
    
    task :package do
      cmd = ""
      cmd << "cd #{engine} && " unless engine == "refinerycms"
      cmd << "gem build #{gemspec} && mv #{engine_name}-#{version}.gem #{root}/pkg/"
      sh cmd
    end
    
    task :build => [:clean, :package]
  end
end

namespace :all do
  task :build => ENGINES.map { |e| "#{e}:build" } + ['refinerycms:build']
end

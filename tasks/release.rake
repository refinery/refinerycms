ENGINES = %w{ authentication core images pages resources testing }

require File.expand_path('../../core/lib/refinery/version', __FILE__)
version = Refinery::Version.to_s
root = File.expand_path('../../', __FILE__)

(ENGINES + ['refinerycms']).each do |extension|
  namespace extension do
    extension_name = extension
    extension_name = "refinerycms-#{extension}" unless extension == "refinerycms"

    gem_filename = "pkg/#{extension_name}-#{version}.gem"
    gemspec = "#{extension_name}.gemspec"

    task :clean do
      package_dir = "#{root}/pkg"
      mkdir_p package_dir unless File.exists?(package_dir)
      rm_f gem_filename
    end

    task :package do
      cmd = ""
      cmd << "cd #{extension} && " unless extension == "refinerycms"
      cmd << "gem build #{gemspec} && mv #{extension_name}-#{version}.gem #{root}/pkg/"
      sh cmd
    end

    task :build => [:clean, :package]
  end
end

namespace :all do
  task :build => ENGINES.map { |e| "#{e}:build" } + ['refinerycms:build']
end

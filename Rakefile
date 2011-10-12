# Ensure that the database has *a* config.
unless File.exist?(db_yml = File.expand_path('../config/database.yml', __FILE__))
  require 'fileutils'
  FileUtils.cp "#{db_yml}.sqlite3", db_yml
  puts "Copied #{db_yml}.sqlite3 to #{db_yml}"
end

# Continue on with Rails.
require File.expand_path('../config/application', __FILE__)
require 'rake'

::RefineryApp::Application.load_tasks

load 'tasks/release.rake'

desc "Build gem files for all projects"
task :build => "all:build"

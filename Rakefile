# Ensure that the database has *a* config.
unless File.exist?(db_yml = File.expand_path('../config/database.yml', __FILE__))
  require 'fileutils'
  FileUtils.cp "#{db_yml}.sqlite3", db_yml
  puts "Copied #{db_yml}.sqlite3 to #{db_yml}"
  puts "Migrating..."
  puts `bundle exec rake -f #{__FILE__} db:migrate`
end

require File.expand_path('../config/application', __FILE__)
require 'rake'

RefineryApp::Application.load_tasks
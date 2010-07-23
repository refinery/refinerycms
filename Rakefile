# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

begin
  # Load up the environment instead of just the boot file because we want all of the tasks available.
  require File.join(File.dirname(__FILE__), 'config', 'application')
rescue Exception
  # Load up the boot file instead because there's something wrong with the environment (like it's not set up yet).
  require File.join(File.dirname(__FILE__), 'config', 'boot')
end

# Require the standard stuff
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

require 'tasks/refinery'
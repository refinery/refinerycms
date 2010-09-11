# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Refinery::Application.load_tasks

# To get specs from all Refinery engines, not just those in Rails.root/spec/
RSpec::Core::RakeTask.module_eval do
  def pattern
    [@pattern] | ::Refinery::Plugins.registered.collect{|p|
                   p.pathname.join('spec','**', '*_spec.rb').to_s
                 }
  end
end

#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

ENGINE_PATH = File.dirname(__FILE__)
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

if File.exists?(APP_RAKEFILE)
  load 'rails/tasks/engine.rake'
end

load 'tasks/common.rake'
load 'tasks/release.rake'

require "refinerycms-testing"
Refinery::Testing::Railtie.load_tasks

desc "Build gem files for all projects"
task :build => "all:build"

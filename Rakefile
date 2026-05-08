#!/usr/bin/env rake
require "bundler/gem_helper"

Bundler::GemHelper.install_tasks(name: "refinerycms")

%w[core dragonfly images pages resources testing].each do |sub_gem|
  namespace sub_gem do
    Bundler::GemHelper.install_tasks(dir: sub_gem, name: "refinerycms-#{sub_gem}")
  end
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake' if File.exist?(APP_RAKEFILE)

Dir[File.expand_path('../tasks/**/*', __FILE__)].each do |task|
  load task
end

require "refinery/testing"
Refinery::Testing::Railtie.load_dummy_tasks File.dirname(__FILE__)

desc "Build gem files for all projects"
task :build => "all:build"

task :default => :spec

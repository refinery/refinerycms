require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => [:clean_db, :test]

desc 'Remove the stale db file'
task :clean_db do
  `rm -f #{File.dirname(__FILE__)}/test/state_machine.sqlite.db`
end

desc 'Test the acts as state machine plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the acts as state machine plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Acts As State Machine'
  rdoc.options << '--line-numbers --inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('TODO')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

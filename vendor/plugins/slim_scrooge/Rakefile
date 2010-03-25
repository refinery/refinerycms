require 'rake'
require 'rake/testtask'
require 'test/helper'

Rake::TestTask.new(:test_with_active_record) do |t|
  t.libs << SlimScrooge::ActiveRecordTest::AR_TEST_SUITE
  t.libs << SlimScrooge::ActiveRecordTest.connection
  t.test_files = SlimScrooge::ActiveRecordTest.test_files
  t.ruby_opts = ["-r #{File.join(File.dirname(__FILE__), 'test', 'active_record_setup')}"]
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "slim_scrooge"
    s.summary = "Slim_scrooge - serious optimisation for ActiveRecord"
    s.email = "sdsykes@gmail.com"
    s.homepage = "http://github.com/sdsykes/slim_scrooge"
    s.description = "Slim scrooge boosts speed in Rails ActiveRecord Models by only querying the database for what is needed."
    s.authors = ["Stephen Sykes"]
    s.files = FileList["[A-Z]*", "{ext,lib,test}/**/*"]
    s.extensions = "ext/Rakefile"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://
gems.github.com"
end

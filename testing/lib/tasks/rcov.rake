# Forked to get it working with Rails 3 and RSpec 2
#
# From http://github.com/jaymcgavren
#
# Save this as rcov.rake in lib/tasks and use rcov:all =>
# to get accurate spec/feature coverage data
#
# Use rcov:rspec
# to get non-aggregated coverage reports for rspec

require "rspec/core/rake_task"

if RUBY_VERSION < '1.9'
  namespace :rcov do
    RSpec::Core::RakeTask.new(:rspec_run) do |t|
      t.pattern = '**/*_spec.rb'
      t.rcov = true
      t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/}
      t.rcov_opts << '--aggregate coverage.data'
      t.rcov_opts << %[-o "coverage"]
    end

    desc "Run only rspecs"
    task :rspec do |t|
      rm "coverage.data" if File.exist?("coverage.data")
      Rake::Task["rcov:rspec_run"].invoke
    end
  end
end 

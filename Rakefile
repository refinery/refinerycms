# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require File.expand_path('../config/environment', __FILE__)
require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# Because we use plugins that are shipped via gems, we lose their rake tasks.
# So here, we find them (if there are any) and include them into rake.
extra_rake_tasks = []
if Refinery.is_a_gem
  extra_rake_tasks << Dir[Refinery.root.join("vendor", "plugins", "*", "**", "tasks", "**", "*", "*.rake")].sort
end

# We also need to load in the rake tasks from gem plugins whether Refinery is a gem or not:
if defined?($refinery_gem_plugin_lib_paths) && !$refinery_gem_plugin_lib_paths.nil?
  extra_rake_tasks << $refinery_gem_plugin_lib_paths.collect {|path| Dir[File.join(%W(#{path} tasks ** *.rake))].sort}
end

# Load in any extra tasks that we've found.
extra_rake_tasks.flatten.compact.uniq.each {|rake| load rake }

desc 'Removes trailing whitespace across the entire application.'
task :whitespace do
  sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
end

# You don't need to worry about this unless you're releasing Refinery gems.
begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = %q{refinerycms}
    s.description = %q{A beautiful open source Ruby on Rails content manager for small business. Easy to extend, easy to use, lightweight and all wrapped up in a super slick UI.}
    s.summary = %q{A beautiful open source Ruby on Rails content manager for small business.}
    s.email = %q{info@refinerycms.com}
    s.homepage = %q{http://refinerycms.com}
    s.authors = ["Resolve Digital", "David Jones", "Philip Arndt"]
    s.extra_rdoc_files = %w(readme.md contributors.md license.md VERSION)
    s.rdoc_options << "--inline-source"
    s.has_rdoc = true
  end

  namespace :version do
    namespace :bump do
      desc "Bump the application's version by a build version."
      task :build => [:version_required, :version] do
        version = Jeweler::VersionHelper.new(Rails.root.to_s)
        version.update_to(version.major, version.minor, version.patch, ((version.build || 0).to_i + 1))
        version.write
        $stdout.puts "Updated version: #{version.to_s}"
      end
    end
  end
rescue LoadError
  #puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

Rails::Application.load_tasks

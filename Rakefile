# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
 
require(File.join(File.dirname(__FILE__), 'config', 'boot'))
 
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
require 'tasks/rails'

desc 'Removes trailing whitespace'
task :whitespace do
  sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
end

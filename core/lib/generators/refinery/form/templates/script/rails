#!/usr/bin/env ruby
# This command will automatically be run when you run "rails" with Rails 3 gems installed from the root of your application.

ENGINE_PATH = File.expand_path('../..',  __FILE__)
dummy_rails_path = File.expand_path('../../spec/dummy/script/rails',  __FILE__)
if File.exist?(dummy_rails_path)
  load dummy_rails_path
else
  puts "Please first run 'rake refinery:testing:dummy_app' to create a dummy Refinery CMS application."
end

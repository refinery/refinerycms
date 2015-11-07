# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separately)
#  * 'just' rspec: 'rspec'

#guard :rspec, cmd: "bundle exec rspec" do
#  require "guard/rspec/dsl"
#  dsl = Guard::RSpec::Dsl.new(self)
#
#  # Feel free to open issues for suggestions and improvements
#
#  # RSpec files
#  rspec = dsl.rspec
#  watch(rspec.spec_helper) { rspec.spec_dir }
#  watch(rspec.spec_support) { rspec.spec_dir }
#  watch(rspec.spec_files)
#
#  # Ruby files
#  ruby = dsl.ruby
#  dsl.watch_spec_files_for(ruby.lib_files)
#
#  # Rails files
#  rails = dsl.rails(view_extensions: %w(erb haml slim))
#  dsl.watch_spec_files_for(rails.app_files)
#  dsl.watch_spec_files_for(rails.views)
#
#  watch(rails.controllers) do |m|
#    [
#      rspec.spec.("routing/#{m[1]}_routing"),
#      rspec.spec.("controllers/#{m[1]}_controller"),
#      rspec.spec.("acceptance/#{m[1]}")
#    ]
#  end
#
#  # Rails config changes
#  watch(rails.spec_helper)     { rspec.spec_dir }
#  watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
#  watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }
#
#  # Capybara features specs
#  watch(rails.view_dirs)     { |m| rspec.spec.("features/#{m[1]}") }
#  watch(rails.layouts)       { |m| rspec.spec.("features/#{m[1]}") }
#
#  # Turnip features and steps
#  watch(%r{^spec/acceptance/(.+)\.feature$})
#  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
#    Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
#  end
#end


engines = [ 
  'core',
  'images',
  'pages',
  'resources'
]

# guard 'spork', :wait => 60, :cucumber => false, :rspec_env => { 'RAILS_ENV' => 'test' } do
#   watch('config/application.rb')
#   watch('config/environment.rb')
#   watch(%r{^config/environments/.+\.rb$})
#   watch(%r{^config/initializers/.+\.rb$})
#   watch('spec/spec_helper.rb')
#   watch(%r{^spec/support/.+\.rb$})
#   
#   engines.each do |engine|
#     watch(%r{^#{engine}/spec/support/.+\.rb$})
#   end
# end

guard 'rspec', :version => 2, :spec_paths => ['core/spec', 'images/spec', 'pages/spec', 'resources/spec'], :cmd => "bundle exec rspec --color" do
  engines.each do |engine|
    watch(%r{^#{engine}/spec/.+_spec\.rb$})
    watch(%r{^#{engine}/app/(.+)\.rb$})                           { |m| "#{engine}/spec/#{m[1]}_spec.rb" }
    watch(%r{^#{engine}/lib/(.+)\.rb$})                           { |m| "#{engine}/spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^#{engine}/app/controllers/(.+)_(controller)\.rb$})  { |m| ["#{engine}/spec/routing/#{m[1]}_routing_spec.rb", "#{engine}/spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "#{engine}/spec/requests/#{m[1]}_spec.rb"] }
    watch(%r{^#{engine}/spec/support/(.+)\.rb$})                  { "#{engine}/spec" }
    watch("#{engine}/spec/spec_helper.rb")                        { "#{engine}/spec" }
    watch("#{engine}/config/routes.rb")                           { "#{engine}/spec/routing" }
    watch("#{engine}/app/controllers/application_controller.rb")  { "#{engine}/spec/controllers" }
    # Capybara request specs
    watch(%r{^#{engine}/app/views/(.+)/.*\.(erb|haml)$})          { |m| "#{engine}/spec/requests/#{m[1]}_spec.rb" }
  end
end

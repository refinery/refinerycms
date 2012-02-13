engines = (ENV['ENGINES'] && ENV['ENGINES'].to_s.split(',')) || %w(
  authentication
  core
  dashboard
  images
  pages
  resources
  settings
)

guard 'spork', :wait => 60, :cucumber => false, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{^spec/support/.+\.rb$})

  engines.each do |engine|
    watch(%r{^#{engine}/spec/support/.+\.rb$})
  end
end

guard 'rspec', :version => 2, :spec_paths => engines.map{|e| "#{e}/spec"},
  :cli => (File.read('.rspec').split("\n").join(' ') if File.exists?('.rspec')) do
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

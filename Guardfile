extensions = (ENV['ENGINES'] && ENV['ENGINES'].to_s.split(',')) || %w(
  authentication
  core
  dashboard
  images
  pages
  resources
)

guard 'spork', :wait => 60, :cucumber => false, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{^spec/support/.+\.rb$})

  extensions.each do |extension|
    watch(%r{^#{extension}/spec/support/.+\.rb$})
  end
end

guard 'rspec', :version => 2, :spec_paths => extensions.map{|e| "#{e}/spec"},
  :cli => (File.read('.rspec').split("\n").join(' ') if File.exists?('.rspec')) do
  extensions.each do |extension|
    watch(%r{^#{extension}/spec/.+_spec\.rb$})
    watch(%r{^#{extension}/app/(.+)\.rb$})                           { |m| "#{extension}/spec/#{m[1]}_spec.rb" }
    watch(%r{^#{extension}/lib/(.+)\.rb$})                           { |m| "#{extension}/spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^#{extension}/app/controllers/(.+)_(controller)\.rb$})  { |m| ["#{extension}/spec/routing/#{m[1]}_routing_spec.rb", "#{extension}/spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "#{extension}/spec/requests/#{m[1]}_spec.rb"] }
    watch(%r{^#{extension}/spec/support/(.+)\.rb$})                  { "#{extension}/spec" }
    watch("#{extension}/spec/spec_helper.rb")                        { "#{extension}/spec" }
    watch("#{extension}/config/routes.rb")                           { "#{extension}/spec/routing" }
    watch("#{extension}/app/controllers/application_controller.rb")  { "#{extension}/spec/controllers" }
    # Capybara request specs
    watch(%r{^#{extension}/app/views/(.+)/.*\.(erb|haml)$})          { |m| "#{extension}/spec/requests/#{m[1]}_spec.rb" }
  end
end

require 'factory_girl'

Refinery::Plugins.registered.pathnames.map do |p|
  Dir[p.join('spec', 'support', '**', 'factories.rb').to_s]
end.flatten.each do |support_file|
  require support_file
end

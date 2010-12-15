# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
# Refinery seeds
Dir[Rails.root.join('db', 'seeds', '*.rb').to_s].each do |file|
  puts "Loading db/seeds/#{file.split(File::SEPARATOR).last}"
  load(file)
end

require 'factory_girl'

Factory.define :image do |i|
  i.image File.new(File.expand_path('../../uploads/beach.jpeg', __FILE__))
end

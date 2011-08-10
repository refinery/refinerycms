Factory.define :image, :class => Refinery::Image do |i|
  i.image File.new(File.expand_path('../../../uploads/beach.jpeg', __FILE__))
end

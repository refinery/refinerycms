FactoryGirl.define do
  factory :image, :class => ::Refinery::Image do |i|
    i.image File.new(File.expand_path('../../../../../assets/beach.jpeg', __FILE__))
  end
end

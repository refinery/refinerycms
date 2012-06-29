FactoryGirl.define do
  factory :image, :class => ::Refinery::Image do
    image Refinery.roots(:'refinery/images').join("spec/fixtures/beach.jpeg")
  end
  
  factory :alternate_image, :class => ::Refinery::Image do
    image Refinery.roots(:'refinery/images').join("spec/fixtures/kitten.jpeg")
  end      
end

FactoryGirl.define do
  factory :image, :class => ::Refinery::Image do
    image Refinery.roots("testing").join("assets/beach.jpeg")
  end
end

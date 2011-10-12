FactoryGirl.define do
  factory :image, :class => ::Refinery::Image do
    image Refinery.roots("images").join("spec/fixtures/beach.jpeg")
  end
end

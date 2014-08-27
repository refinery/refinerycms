FactoryGirl.define do
  factory :image, :class => ::Refinery::Image do
    image Refinery.roots('refinery/images').join("spec/fixtures/beach.jpeg")
  end

  factory :alternate_image, :class => ::Refinery::Image do
    image Refinery.roots('refinery/images').join("spec/fixtures/beach-alternate.jpeg")
  end

  factory :another_image, :class => ::Refinery::Image do
    image Refinery.roots('refinery/images').join("spec/fixtures/fathead.png")
  end
end

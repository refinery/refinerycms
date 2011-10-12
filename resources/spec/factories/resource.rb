FactoryGirl.define do
  factory :resource, :class => Refinery::Resource do
    file Refinery.roots("resources").join("spec/fixtures/refinery_is_awesome.txt")
  end
end

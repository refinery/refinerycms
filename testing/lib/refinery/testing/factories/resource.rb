FactoryGirl.define do
  factory :resource, :class => Refinery::Resource do |r|
    r.file Refinery.roots("testing").join("assets/refinery_is_awesome.txt")
  end
end

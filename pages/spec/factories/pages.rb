FactoryGirl.define do
  factory :page, :class => Refinery::Page do
    sequence(:title, "a") {|n| "Test title #{n}" }
  end
end

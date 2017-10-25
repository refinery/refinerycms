
FactoryGirl.define do
  factory :api, :class => Refinery::Apis::Api do
    sequence(:title) { |n| "refinery#{n}" }
  end
end


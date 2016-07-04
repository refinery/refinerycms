FactoryGirl.define do
  factory :page, :class => Refinery::Page do
    sequence(:title, "a") {|n| "Test title #{n}" }

    trait :site_specific do
      site
    end
  end

  factory :site, :class => Refinery::Site do
    sequence(:name, "a") {|x| "Site #{x}"}
    sequence(:hostname, "a") {|x| "#{x}.foobar.com"}
  end
end

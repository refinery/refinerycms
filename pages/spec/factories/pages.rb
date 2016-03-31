FactoryGirl.define do
  factory :page, class: Refinery::Page do
    sequence(:title, "a") { |n| "Test title #{n}" }

    factory :page_with_page_part do
      after(:create) do |page|
        page.parts << FactoryGirl.create(:page_part)
      end
    end
  end
end

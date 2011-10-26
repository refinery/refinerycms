# This is a temporary hack to get around some fuckery with Devise when
# using the authentication macros in request specs that are defined in
# refinerycms-testing. If you remove this line ensure that tests pass
# in an engine that is testing against this Factory via the
# authentication macros in refinerycms-testing.
# 10-11-2011 - Jamie Winsor - jamie@enmasse.com
require Refinery.roots(:'refinery/authentication').join("app/models/refinery/role.rb")

FactoryGirl.define do
  factory :user, :class => Refinery::User do
    sequence(:username) { |n| "refinery#{n}" }
    sequence(:email) { |n| "refinery#{n}@refinerycms.com" }
    password  "refinerycms"
    password_confirmation "refinerycms"
  end

  factory :refinery_user, :parent => :user do
    roles { [ ::Refinery::Role[:refinery] ] }

    after_create do |user|
      ::Refinery::Plugins.registered.each_with_index do |plugin, index|
        user.plugins.create(:name => plugin.name, :position => index)
      end
    end
  end

  factory :refinery_translator, :parent => :user do
    roles { [ ::Refinery::Role[:refinery], ::Refinery::Role[:translator] ] }

    after_create do |user|
      user.plugins.create(:name => 'refinery_pages', :position => 0)
    end
  end
end

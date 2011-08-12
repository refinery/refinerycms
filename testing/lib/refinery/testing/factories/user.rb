require 'refinery/user'
require 'refinery/role'

FactoryGirl.define do
  
  factory :user, :class => ::Refinery::User do |u|
    u.sequence(:username) { |n| "person#{n}" }
    u.sequence(:email) { |n| "person#{n}@cucumber.com" }
    u.password  "greenandjuicy"
    u.password_confirmation "greenandjuicy"
  end

  factory :refinery_user, :parent => :user do |u|
    u.roles { [ ::Refinery::Role[:refinery] ] }

    u.after_create do |user|
      ::Refinery::Plugins.registered.each_with_index do |plugin, index|
        user.plugins.create(:name => plugin.name, :position => index)
      end
    end
  end

  factory :refinery_translator, :parent => :user do |u|
    u.roles { [ ::Refinery::Role[:refinery], ::Refinery::Role[:translator] ] }

    u.after_create do |user|
      user.plugins.create(:name => 'refinery_pages', :position => 0)
    end
  end
  
end

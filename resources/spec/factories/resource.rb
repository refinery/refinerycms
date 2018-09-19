# frozen_string_literal: true

FactoryBot.define do
  factory :resource, class: Refinery::Resource do
    file Refinery.roots('refinery/resources').join('spec/fixtures/cape-town-tide-table.pdf')
  end
end

# frozen_string_literal: true

module Refinery
  module Api
    module Fields
      module Pages
        class PagesField < GraphQL::Schema::Field
          name 'Pages'
          description 'Find all pages'

          type types[Types::Pages::PageType]

          resolve -> (obj, args, ctx) {
            Refinery::Page.all
          }
        end
      end
    end
  end
end
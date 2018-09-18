# frozen_string_literal: true

module Refinery
  module Api
    module Queries
      module Pages
        class PageQuery < GraphQL::Field.define do
          name 'Page'
          description 'Find a page by ID'

          type Types::Pages::PageType
          argument :id, !types.ID

          resolve -> (obj, args, ctx) {
            Refinery::Page.find_by_id(args[:id])
          }
        end
      end
    end
  end
end

# frozen_string_literal: true

field :page, Types::Pages::PageType,
              null: true, resolve: Resolvers::Pages::PageResolver::ById do
          description "Find page by id"
          guard ->(_obj, _args, ctx) { ctx[:current_user].has_plugin?('refinery_pages') }
          argument :id, ID, required: true
        end
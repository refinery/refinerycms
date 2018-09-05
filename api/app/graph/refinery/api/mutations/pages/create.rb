# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Create < GraphQL::Schema::Mutation
          graphql_name 'CreatePage'
          description 'Create a page'

          argument :page, !Types::Pages::PageType

          type Types::Pages::PageType

          resolve -> (obj, inputs, ctx) {
            inputs = inputs.to_h.deep_symbolize_keys

            page = Refinery::Page.create!(inputs[:page])

            { page: page }
          }
        end
      end
    end
  end
end
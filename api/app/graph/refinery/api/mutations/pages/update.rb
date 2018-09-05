# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Update < GraphQL::Schema::Mutation
          graphql_name 'UpdatePage'
          description 'Create a page'

          input_field :id, !types.ID
          input_field :page, !Inputs::Pages::PageInput

          return_field :page, Types::Pages::PageType

          resolve -> (obj, inputs, ctx) {
            inputs = inputs.to_h.deep_symbolize_keys

            page = Refinery::Page.update(inputs[:id], inputs[:page])

            { page: page }
          }
        end
      end
    end
  end
end
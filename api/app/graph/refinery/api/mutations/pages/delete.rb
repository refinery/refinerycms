# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Delete < GraphQL::Schema::Mutation
          name 'DeletePage'

          input_field :id, !types.ID

          return_field :page, Types::Pages::PageType

          resolve -> (obj, inputs, ctx) {
            page = Refinery::Page.destroy(inputs[:id])

            { page: page }
          }
        end
      end
    end
  end
end
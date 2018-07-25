# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Create < GraphQL::Schema::Mutation
          name 'CreatePage'
          description 'Create a page'

          input_field :page, !Inputs::Pages::PageInput

          return_field :page, Types::Pages::PageType

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
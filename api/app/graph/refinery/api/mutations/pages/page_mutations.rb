# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        module PageMutations
          Create = GraphQL::Relay::Mutation.define do
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

          Update = GraphQL::Relay::Mutation.define do
            name 'UpdatePage'
            description 'Create a page'

            input_field :id, !types.ID
            input_field :page, !Inputs::Pages::PageInput

            return_field :page, Types::Pages::PageType

            resolve -> (obj, inputs, ctx) {
              inputs = inputs.to_h.deep_symbolize_keys

              Refinery::Page.update(inputs[:id], inputs[:page])

              { page: page }
            }
          end

          Delete = GraphQL::Relay::Mutation.define do
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
end
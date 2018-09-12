# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Create < Mutations::BaseMutation
          graphql_name 'CreatePage'
          description 'Create a Page'

          argument :page, Types::Pages::PageAttributes, required: true

          field :page, Types::Pages::PageType, null: true
          field :errors, [String], null: false

          def resolve(page:)
            page = Refinery::Page.create!(page.to_h)

            if page.errors.empty?
              {
                page: page,
                errors: []
              }
            else
              {
                page: nil,
                errors: page.errors.full_messages
              }
            end
          end
        end
      end
    end
  end
end
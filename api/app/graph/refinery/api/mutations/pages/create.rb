# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Create < Mutations::BaseMutation
          null true

          graphql_name 'CreatePage'
          description 'Create a Page'

          field :page, Types::Pages::PageAttributes, null: true
          field :errors, [String], null: false

          def resolve(page:)
            page = Refinery::Page.create!(page)

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
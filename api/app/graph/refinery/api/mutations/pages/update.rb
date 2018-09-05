# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Update < Mutations::BaseMutation
          graphql_name 'UpdatePage'
          description 'Update a Page'

          argument :id, ID, required: true

          field :page, Types::Pages::PageType, null: false
          field :errors, [String], null: false

          def resolve(id:, page:)
            page = Refinery::Page.update(id, page)

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
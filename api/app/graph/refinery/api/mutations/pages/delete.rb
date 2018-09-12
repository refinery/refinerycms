# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Delete < Mutations::BaseMutation
          graphql_name 'DeletePage'
          description 'Delete a Page'

          argument :id, ID, required: true

          field :page, Types::Pages::PageType, null: true
          field :errors, [String], null: false

          def resolve(id:)
            page = Refinery::Page.destroy(id)

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
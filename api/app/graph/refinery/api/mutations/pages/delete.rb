# frozen_string_literal: true

module Refinery
  module Api
    module Mutations
      module Pages
        class Delete <  Mutations::BaseMutation
          graphql_name 'DeletePage'

          argument :id, ID, required: true

          return_field :page, Types::Pages::PageType

          resolve -> (id:) {
            page = Refinery::Page.destroy!(id)

            { page: page }
          }
        end
      end
    end
  end
end
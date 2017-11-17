# frozen_string_literal: true

module Refinery
  module Api
    module Types
      MutationType = GraphQL::ObjectType.define do
        name 'Mutation'
        description 'The mutation root for this schema'

        field :create_page, field: Mutations::Pages::PageMutations::Create.field
        field :update_page, field: Mutations::Pages::PageMutations::Update.field
        field :delete_page, field: Mutations::Pages::PageMutations::Delete.field
      end
    end
  end
end
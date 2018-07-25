# frozen_string_literal: true

module Refinery
  module Api
    module Types
      class MutationType < Types::BaseObject
        name 'Mutation'
        description 'The mutation root for this schema'

        field :createPage, mutation: Mutations::Pages::Create
        field :updatePage, mutation: Mutations::Pages::Update
        field :deletePage, mutation: Mutations::Pages::Delete
      end
    end
  end
end
# frozen_string_literal: true

module Refinery
  module Api
    module Types
      PageType = GraphQL::ObjectType.define do
        name "Page"
        description "A Page"

        interfaces [Types::ActiveRecordInterface]

        field :title, types.String
      end
    end
  end
end
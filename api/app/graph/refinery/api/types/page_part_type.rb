# frozen_string_literal: true

module Refinery
  module Api
    module Types
      PagePartType = GraphQL::ObjectType.define do
        name "PagePart"
        description "A PagePart"

        interfaces [Types::ActiveRecordInterface]

        field :slug, types.String
        field :position, types.Int
        field :title, types.String

        field :locale, types.String
        field :body, types.String
      end
    end
  end
end
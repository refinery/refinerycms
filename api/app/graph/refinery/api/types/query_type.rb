# frozen_string_literal: true

module Refinery
  module Api
    module Types
      QueryType = GraphQL::ObjectType.define do
        name 'Query'
        description 'The query root of this schema'

        field :page, field: Fields::PageField
        # field :pages, field: Refinery::Api::Fields::PagesField
      end
    end
  end
end
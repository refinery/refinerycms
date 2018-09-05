# frozen_string_literal: true

module Refinery
  module Api
    module Types
      class QueryType < Types::BaseObject
        graphql_name 'Query'
        description 'The query root of this schema'

        field :pages, [Types::Pages::PageType],
              null: true, resolve: Resolvers::Pages::PageResolver::All do
          description "All pages"
        end

        field :page, Types::Pages::PageType,
              null: true, resolve: Resolvers::Pages::PageResolver::ById do
          argument :id, ID, required: true
          description "Find page by id"
        end
      end
    end
  end
end
# frozen_string_literal: true

module Refinery
  module Api
    module Types
      class QueryType < Types::BaseObject
        graphql_name 'Query'
        description 'The query root of this schema'

        # field :pages, [Types::Pages::PageType],
        #       null: true, resolve: Resolvers::Pages::PageResolver::All do
        #   description "All pages"
        #   guard ->(_obj, _args, ctx) { ctx[:current_user].has_plugin?('refinery_pages') }
        # end

        field :page, field: Queries::Pages::PageQuery
        field :pages, field: Queries::Pages::PagesQuery


        # field :page, Types::Pages::PageType,
        #       null: true, resolve: Resolvers::Pages::PageResolver::ById do
        #   description "Find page by id"
        #   guard ->(_obj, _args, ctx) { ctx[:current_user].has_plugin?('refinery_pages') }
        #   argument :id, ID, required: true
        # end
      end
    end
  end
end
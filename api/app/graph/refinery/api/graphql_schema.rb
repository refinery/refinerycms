# frozen_string_literal: true

module Refinery
  module Api
    class GraphqlSchema < GraphQL::Schema
      query Types::QueryType
      mutation Types::MutationType

      resolve_type -> (obj, args, ctx) {
        type_name = obj.class.name
        Schema.types[type_name]
      }
    end
  end
end

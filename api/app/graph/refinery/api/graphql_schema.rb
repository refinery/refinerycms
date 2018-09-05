# frozen_string_literal: true

module Refinery
  module Api
    class GraphqlSchema < GraphQL::Schema
      mutation Types::MutationType
      query Types::QueryType
    end
  end
end
# frozen_string_literal: true

module Refinery
  module Api
    class GraphqlSchema < GraphQL::Schema
      mutation Types::MutationType
      query Types::QueryType
      use GraphQL::Guard.new
    end
  end
end
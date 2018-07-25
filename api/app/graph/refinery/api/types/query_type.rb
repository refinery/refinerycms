# frozen_string_literal: true

module Refinery
  module Api
    module Types
      class QueryType < Types::BaseObject
        name 'Query'
        description 'The query root of this schema'

        field :page, field: Fields::Pages::PageField
        field :pages, field: Fields::Pages::PagesField
      end
    end
  end
end
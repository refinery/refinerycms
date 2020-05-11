# frozen_string_literal: true

module Refinery
  module Api
    module Types
      module Pages
        class PagePartType < GraphQL::Schema::Object
          graphql_name "PagePart"
          description "A PagePart"

          field :slug, String, null: true
          field :position, Integer, null: true
          field :title, String, null: true

          field :locale, String, null: true
          field :body, String, null: true
        end
      end
    end
  end
end
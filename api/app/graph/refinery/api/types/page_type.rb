# frozen_string_literal: true

module Refinery
  module Api
    module Types
      PageType = GraphQL::ObjectType.define do
        name "Page"
        description "A Page"

        interfaces [Types::ActiveRecordInterface]

        field :parent_id, types.Int
        field :path, types.String
        field :show_in_menu, types.Boolean
        field :link_url, types.String
        field :menu_match, types.String
        field :deletable, types.Boolean
        field :draft, types.Boolean
        field :skip_to_first_child, types.Boolean
        field :lft, types.Int
        field :rgt, types.Int
        field :depth, types.Int
        field :view_template, types.String
        field :layout_template, types.String

        field :locale, types.String
        field :title, types.String
        field :custom_slug, types.String
        field :menu_title, types.String
        field :slug, types.String

        field :meta_description, types.String
        field :browser_title, types.String

        field :parts, types[Types::PagePartType]
      end
    end
  end
end
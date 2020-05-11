# frozen_string_literal: true

module Refinery
  module Api
    module Types
      module Pages
        class PageType < GraphQL::Schema::Object
          graphql_name "Page"
          description "A Page"

          field :id, Integer, null: false
          field :parent_id, Integer, null: true
          field :path, String, null: true
          field :show_in_menu, Boolean, null: true
          field :link_url, String, null: true
          field :menu_match, String, null: true
          field :deletable, Boolean, null: true
          field :draft, Boolean, null: true
          field :skip_to_first_child, Boolean, null: true
          field :lft, Integer, null: true
          field :rgt, Integer, null: true
          field :depth, Integer, null: true
          field :view_template, String, null: true
          field :layout_template, String, null: true
          field :locale, String, null: true
          field :title, String, null: true
          field :custom_slug, String, null: true
          field :menu_title, String, null: true
          field :slug, String, null: true
          field :meta_description, String, null: true
          field :browser_title, String, null: true

          field :parts, [PagePartType], null: true
        end
      end
    end
  end
end
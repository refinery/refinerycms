# frozen_string_literal: true

module Refinery
  module Api
    module Inputs
      module Pages
        PageInput = GraphQL::InputObjectType.define do
          name 'PageInput'

          input_field :parent_id, types.Int
          input_field :path, types.String
          input_field :show_in_menu, types.Boolean
          input_field :link_url, types.String
          input_field :menu_match, types.String
          input_field :deletable, types.Boolean
          input_field :draft, types.Boolean
          input_field :skip_to_first_child, types.Boolean
          input_field :lft, types.Int
          input_field :rgt, types.Int
          input_field :depth, types.Int
          input_field :view_template, types.String
          input_field :layout_template, types.String
          input_field :locale, types.String
          input_field :title, types.String
          input_field :custom_slug, types.String
          input_field :menu_title, types.String
          input_field :slug, types.String
          input_field :meta_description, types.String
          input_field :browser_title, types.String

          input_field :parts, types[Inputs::Pages::PagePartInput]
        end
      end
    end
  end
end
# frozen_string_literal: true

module Refinery
  module Api
    module Types
      module Pages
        class PageAttributes < Types::BaseInputObject
          description "Attributes for creating or updating a page"

          argument :parent_id, Integer, required: false
          argument :path, String, required: false
          argument :show_in_menu, Boolean, required: false
          argument :link_url, String, required: false
          argument :menu_match, String, required: false
          argument :deletable, Boolean, required: false
          argument :draft, Boolean, required: false
          argument :skip_to_first_child, Boolean, required: false
          argument :lft, Integer, required: false
          argument :rgt, Integer, required: false
          argument :depth, Integer, required: false
          argument :view_template, String, required: false
          argument :layout_template, String, required: false
          argument :locale, String, required: false
          argument :title, String, required: false
          argument :custom_slug, String, required: false
          argument :menu_title, String, required: false
          argument :slug, String, required: false
          argument :meta_description, String, required: false
          argument :browser_title, String, required: false

          argument :parts, [PagePartAttributes], required: false
        end
      end
    end
  end
end



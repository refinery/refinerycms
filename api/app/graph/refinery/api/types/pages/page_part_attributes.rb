# frozen_string_literal: true

module Refinery
  module Api
    module Types
      module Pages
        class PagePartAttributes < Types::BaseInputObject
          description "Attributes for creating or updating a page part"

          argument :slug, String, required: false
          argument :position, Integer, required: false
          argument :title, String, required: false

          argument :locale, String, required: false
          argument :body, String, required: false
        end
      end
    end
  end
end
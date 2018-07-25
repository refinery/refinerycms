# frozen_string_literal: true

module Refinery
  module Api
    module Inputs
      module Pages
        class PagePartInput < GraphQL::Schema::InputObject
          name 'PagePartInput'

          input_field :slug, types.String
          input_field :position, types.Int
          input_field :title, types.String

          input_field :locale, types.String
          input_field :body, types.String
        end
      end
    end
  end
end
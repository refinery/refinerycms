# frozen_string_literal: true

module Refinery
  module Api
    module Types
      class BaseInterface
        include GraphQL::Schema::Interface
      end
    end
  end
end
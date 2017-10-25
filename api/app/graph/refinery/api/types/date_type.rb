# frozen_string_literal: true

module Refinery
  module Api
    module Types
      DateType = GraphQL::ScalarType.define do
        name "Date"
        description "Valid date format (parsable by Ruby's Date.parse)"

        coerce_input -> (value, context) do
          begin Date.parse(value)
          value.to_datetime
          rescue ArgumentError => error
            context.errors << error.message
          end
        end

        coerce_result -> (value, context) do
          value.to_datetime
        end
      end
    end
  end
end
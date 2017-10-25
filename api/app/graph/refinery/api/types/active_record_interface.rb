# frozen_string_literal: true

module Refinery
  module Api
    module Types
      ActiveRecordInterface = GraphQL::InterfaceType.define do
        name "ActiveRecord"
        description "Active Record Interface"

        field :id, !types.ID
        field :updated_at do
          type Types::DateType
          resolve -> (obj, args, ctx) {
            obj.updated_at
          }
        end
        field :created_at do
          type Types::DateType
          resolve -> (obj, args, ctx) {
            obj.created_at
          }
        end
      end
    end
  end
end
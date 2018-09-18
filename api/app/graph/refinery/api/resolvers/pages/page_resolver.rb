# frozen_string_literal: true

module Refinery
  module Api
    module Resolvers
      module Pages
        class PageResolver
          class All
            def self.call(_obj, args, ctx)
              if ctx[:current_user].has_role?(:refinery)
                Refinery::Page.all
              else
                Refinery::Page.live
              end
            end
          end

          class ById
            def self.call(_obj, args, ctx)
              if ctx[:current_user].has_role?(:refinery)
                Refinery::Page.find_by_id(args[:id])
              else
                Refinery::Page.live.find_by_id(args[:id])
              end
            end
          end
        end
      end
    end
  end
end
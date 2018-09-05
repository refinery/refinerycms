module Refinery
  module Api
    module Resolvers
      module Pages
        class PageResolver
          class All
            def self.call(obj, args, ctx)
              Refinery::Page.live
            end
          end

          class ById
            def self.call(obj, args, ctx)
              Refinery::Page.find_by_id(args[:id])
            end
          end
        end
      end
    end
  end
end
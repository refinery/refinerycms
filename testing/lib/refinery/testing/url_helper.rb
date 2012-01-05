module Refinery
  module Testing
    module UrlHelper
      def refinery
        Refinery::Core::Engine.routes.url_helpers
      end
    end
  end
end

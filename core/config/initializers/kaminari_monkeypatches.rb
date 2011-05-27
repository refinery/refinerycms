module Kaminari
  module Helpers
    class Tag
      # Handle isolate_namespace properly
      def page_url_for(page)
        @template.main_app.url_for @params.merge(@param_name => (page <= 1 ? nil : page))
      end
    end
  end
end

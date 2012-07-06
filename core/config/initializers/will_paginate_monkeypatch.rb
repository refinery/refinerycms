require "will_paginate/view_helpers/action_view"

module WillPaginate
  module ActionView
    class LinkRenderer < ViewHelpers::LinkRenderer
      def url(page)
        @base_url_params ||= begin
          url_params = merge_get_params(default_url_params)
          merge_optional_params(url_params)
        end

        url_params = @base_url_params.dup
        add_current_page_param(url_params, page)

        if /refinery/ === url_params[:controller]
          @template.refinery.url_for(url_params)
        else
          @template.url_for(url_params)
        end
      end
    end
  end
end

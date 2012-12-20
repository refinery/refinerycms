module Refinery
  module Pages
    module RenderOptions

      def render_options_for_template(page)
        render_options = {}
        if Refinery::Pages.use_layout_templates && page.layout_template.present?
          render_options[:layout] = page.layout_template
        end
        if Refinery::Pages.use_view_templates && page.view_template.present?
          render_options[:action] = "/refinery/pages/#{page.view_template}"
        end
        render_options
      end

      def render_with_templates?(page = @page, render_options = {})
        render_options.update render_options_for_template(page)
        render render_options
      end

      protected :render_options_for_template, :render_with_templates?

    end
  end
end

module Refinery
  module Pages
    module RenderOptions

      def render_options_for_template(page)
        render_options = {}
        if Refinery::Pages.use_layout_templates && page.layout_template.present?
          render_options[:layout] = page.layout_template
        end

        template = page.link_url == "/" ? "home" : "show"

        render_options[:template] = "refinery/pages/#{page.view_template.presence || template}"

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

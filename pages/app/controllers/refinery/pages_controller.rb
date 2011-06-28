module Refinery
  class PagesController < ::ApplicationController
    # Save whole Page after delivery
    after_filter { |c| c.write_cache? }

    # This action is usually accessed with the root path, normally '/'
    def home
      error_404 unless (@page = ::Refinery::Page.where(:link_url => '/').first).present?
    end

    # This action can be accessed normally, or as nested pages.
    # Assuming a page named "mission" that is a child of "about",
    # you can access the pages with the following URLs:
    #
    #   GET /pages/about
    #   GET /about
    #
    #   GET /pages/mission
    #   GET /about/mission
    #
    def show
      @page ||= ::Refinery::Page.find("#{params[:path]}/#{params[:id]}".split('/').last)

      if @page.try(:live?) || (refinery_user? && current_refinery_user.authorized_plugins.include?("refinery_pages"))
        # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
        if @page.skip_to_first_child && (first_live_child = @page.children.order('lft ASC').live.first).present?
          redirect_to first_live_child.url
        end
      else
        error_404
      end

      render_with_templates?
    end

  protected
    def render_with_templates?
      layouts = ::Refinery::Setting.find_or_set(:use_layout_templates, false, :scoping => 'pages')
      views   = ::Refinery::Setting.find_or_set(:use_view_templates, false, :scoping => 'pages')

      render_options = {}
      render_options[:layout] = @page.layout_template if layouts && @page.layout_template.present?
      render_options[:action] = @page.view_template if views && @page.view_template.present?

      render render_options if render_options.any?
    end

    def write_cache?
      if ::Refinery::Setting.find_or_set(:cache_pages_full, {
        :restricted => true,
        :value => false,
        :form_value_type => 'check_box'
      })
        cache_page(response.body, File.join('', 'refinery', 'cache', 'pages', request.path).to_s)
      end
    end
  end
end

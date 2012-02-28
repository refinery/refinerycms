module Refinery
  class PagesController < ::ApplicationController
    before_filter :find_page, :except => [:preview]

    # Save whole Page after delivery
    after_filter { |c| c.write_cache? }

    # This action is usually accessed with the root path, normally '/'
    def home
      render_with_templates?
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
      if current_user_can_view_page?
        if should_skip_to_first_child?
          redirect_to refinery.url_for(first_live_child.url)
        elsif page.link_url.present?
          redirect_to page.link_url
        else
          if requested_friendly_id != page.friendly_id
            redirect_to refinery.url_for(page.url), :status => 301
          else
            render_with_templates?
          end
        end
      else
        error_404
      end
    end

    def preview
      if page(fallback_to_404 = false)
        # Preview existing pages
        @page.attributes = params[:page]
      elsif params[:page]
        # Preview a non-persisted page
        @page = Page.new(params[:page])
      end

      render_with_templates?(:action => :show)
    end

  protected

    def requested_friendly_id
      "#{params[:path]}/#{params[:id]}".split('/').last
    end

    def should_skip_to_first_child?
      page.skip_to_first_child && first_live_child
    end

    def current_user_can_view_page?
      page.live? || current_refinery_user_can_access?("refinery_pages")
    end

    def current_refinery_user_can_access?(plugin)
      refinery_user? && current_refinery_user.authorized_plugins.include?(plugin)
    end

    def first_live_child
      page.children.order('lft ASC').live.first
    end

    def find_page(fallback_to_404 = true)
      @page ||= case action_name
                when "home"
                  Refinery::Page.where(:link_url => '/').first
                when "show", "preview"
                  Refinery::Page.find_by_path_or_id(params[:path], params[:id])
                end
      @page || (error_404 if fallback_to_404)
    end

    alias_method :page, :find_page

    def render_with_templates?(render_options = {})
      if Refinery::Pages.use_layout_templates && page.layout_template.present?
        render_options[:layout] = page.layout_template
      end
      if Refinery::Pages.use_view_templates && page.view_template.present?
        render_options[:action] = page.view_template
      end
      render render_options if render_options.any?
    end

    def write_cache?
      if Refinery::Pages.cache_pages_full
        cache_page(response.body, File.join('', 'refinery', 'cache', 'pages', request.path.sub("//", "/")).to_s)
      end
    end
  end
end

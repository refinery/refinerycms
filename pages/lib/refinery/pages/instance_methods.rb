module Refinery
  module Pages
    module InstanceMethods

      def error_404(exception=nil)
        if (@page = ::Page.where(:menu_match => "^/404$").includes(:parts, :slugs).first).present?
          # render the application's custom 404 page with layout and meta.
          render :template => "/pages/show",
                 :format => 'html',
                 :status => 404
        else
          super
        end
      end

    protected
      def find_pages_for_menu
        # First, apply a filter to determine which pages to show.
        pages = ::Page.live.in_menu

        # Now we only want to select particular columns to avoid any further queries.
        # Title is retrieved in the next block below so it's not here.
        %w(id parent_id lft rgt link_url menu_match).each do |column|
          pages = pages.select(::Page.arel_table[column.to_sym])
        end

        # If we have translations then we get the title from that table.
        if ::Page.respond_to?(:translation_class)
          pages = pages.joins(:translations).select("`#{::Page.translation_class.table_name}`.`title` as page_title")
        else
          pages = pages.select("title as page_title")
        end

        # Cache the slug's name for the menu url.
        pages = pages.joins(:slug).select("`#{Slug.table_name}`.`name` AS to_param_cache")

        # Set the slug to use to_param_cache
        current_cache_column = ::Page.friendly_id_config.cache_column
        ::Page.friendly_id_config.cache_column = 'to_param_cache'

        # Compile the menu.
        @menu_pages = ::Refinery::Menu.new(pages.map(&:to_refinery_menu_item))

        # Now we can set it back
        ::Page.friendly_id_config.cache_column = current_cache_column

        # Return @menu_pages.
        @menu_pages
      end

      def render(*args)
        present(@page) unless admin? or @meta.present?
        super
      end

    private
      def store_current_location!
        return super if admin?

        session[:website_return_to] = url_for(@page.url) if @page.try(:present?)
      end

    end
  end
end

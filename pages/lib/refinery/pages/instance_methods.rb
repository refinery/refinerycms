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
        pages = ::Page.roots.live.in_menu
        %w(id parent_id lft rgt link_url menu_match).each do |column|
          pages = pages.select(::Page.arel_table[column.to_sym])
        end

        if ::Page.respond_to?(:translation_class)
          pages = pages.joins(:translations).select("`#{::Page.translation_class.table_name}`.`title` as page_title")
        else
          pages = pages.select("title as page_title")
        end

        pages = pages.joins(:slug).select("`#{Slug.table_name}`.`name` AS to_param_cache")

        @menu_pages = ::Refinery::Menu.new(pages.map(&:to_refinery_menu_item))
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

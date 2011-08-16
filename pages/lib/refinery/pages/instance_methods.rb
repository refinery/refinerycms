module Refinery
  module Pages
    module InstanceMethods

      def error_404(exception=nil)
        if (@page = ::Refinery::Page.where(:menu_match => "^/404$").includes(:parts, :slugs).first).present?
          # render the application's custom 404 page with layout and meta.
          render :template => '/pages/show', :format => 'html', :status => 404
        else
          super
        end
      end

    protected
      def find_pages_for_menu
        # First, apply a filter to determine which pages to show.
        # We need to join to the page's slug to avoid multiple queries.
        pages = ::Refinery::Page.live.in_menu.includes(:slug).order('lft ASC')

        # Now we only want to select particular columns to avoid any further queries.
        # Title and menu_title are retrieved in the next block below so they are not here.
        %w(id depth parent_id lft rgt link_url menu_match).each do |column|
          pages = pages.select(::Refinery::Page.arel_table[column.to_sym])
        end


        # We have to get title and menu_title from the translations table.
        # To avoid calling globalize3 an extra time, we get title as page_title
        # and we get menu_title as page_menu_title.  
        # These is used in 'to_refinery_menu_item' in the Page model.
        %w(title menu_title).each do |column|
          pages = pages.joins(:translations).select(
              "#{::Refinery::Page.translation_class.table_name}.#{column} as page_#{column}"
            )
        end

        # Compile the menu
        @menu_pages = ::Refinery::Menu.new(pages)
      end

      def render(*args)
        present(@page) unless admin? or @meta.present?
        super
      end

    private
      def store_current_location!
        return super if admin?

        session[:website_return_to] = main_app.url_for(@page.url) if @page.try(:present?)
      end

    end
  end
end

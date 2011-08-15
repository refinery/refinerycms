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
        # Title is retrieved in the next block below so it's not here.
        %w(id depth parent_id lft rgt link_url menu_match).each do |column|
          pages = pages.select(::Refinery::Page.arel_table[column.to_sym])
        end

        # If we have translations then we get the title from that table.
        pages = if ::Refinery::Page.respond_to?(:translation_class)
          pages.joins(:translations).select(
            %w(title menu_title).each do |column|
              "#{::Refinery::Page.translation_class.arel_table[column.to_sym]}"  
            end
          )
        else
          pages.select('title as page_title')
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

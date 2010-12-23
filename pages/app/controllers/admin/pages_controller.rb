module Admin
  class PagesController < Admin::BaseController

    crudify :page,
            :conditions => {:parent_id => nil},
            :order => "lft ASC",
            :include => [:parts, :slugs, :children, :parent, :translations],
            :paging => false

    rescue_from FriendlyId::ReservedError, :with => :show_errors_for_reserved_slug

    cache_sweeper :page_sweeper, :only => [:create, :update, :destroy, :update_positions]

    def new
      @page = Page.new
      Page.default_parts.each_with_index do |page_part, index|
        @page.parts << PagePart.new(:title => page_part, :position => index)
      end
    end

  protected

    def globalize!
      Thread.current[:globalize_locale] = (params[:switch_locale] || (@page.present? && @page.slug.locale) || ::Refinery::I18n.default_frontend_locale)
    end

    def show_errors_for_reserved_slug(exception)
      flash[:error] = "Sorry, but that title is a reserved system word."
      if params[:action] == 'update'
        find_page
        render :edit
      else
        @page = Page.new(params[:page])
        render :new
      end
    end

  end
end

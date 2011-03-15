module Admin
  class PagesController < Admin::BaseController

    crudify :page,
            :conditions => nil,
            :order => "lft ASC",
            :include => [:slugs, :translations],
            :paging => false

    rescue_from FriendlyId::ReservedError, :with => :show_errors_for_reserved_slug

    after_filter lambda{::Page.expire_page_caching}, :only => [:update_positions]

    def new
      @page = Page.new
      Page.default_parts.each_with_index do |page_part, index|
        @page.parts << PagePart.new(:title => page_part, :position => index)
      end
    end

  protected

    def globalize!
      super

      # Check whether we need to override e.g. on the pages form.
      unless params[:switch_locale] or @page.try(:slug).nil? or !@page.persisted?
        Thread.current[:globalize_locale] = @page.slug.locale
      end
    end

    def show_errors_for_reserved_slug(exception)
      flash[:error] = t('reserved_system_word', :scope => 'admin.pages')
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

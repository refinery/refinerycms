class Admin::PagesController < Admin::BaseController

  crudify :page,
          :conditions => "pages.parent_id IS NULL",
          :order => "position ASC",
          :include => [:parts, :slugs, :children, :parent],
          :paging => false

  after_filter :expire_caching, :only => [:create, :update, :destroy, :update_positions]

  rescue_from FriendlyId::ReservedError, :with => :show_errors_for_reserved_slug

  def new
    @page = Page.new
    Page.default_parts.each_with_index do |page_part, index|
      @page.parts << PagePart.new(:title => page_part, :position => index)
    end
  end

protected
  def expire_caching
    expire_menu_fragment_caching
    expire_action_caching
  end

  def expire_menu_fragment_caching
    Rails.cache.delete("#{Refinery.base_cache_key}_menu_pages")
    expire_fragment %r{#{RefinerySetting.find_or_set(:refinery_menu_cache_action_suffix, "site_menu")}}
  end

  def expire_action_caching
    expire_fragment %r{.*/pages/.*}
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

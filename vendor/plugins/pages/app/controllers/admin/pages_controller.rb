class Admin::PagesController < Admin::BaseController

  crudify :page, :conditions => "parent_id IS NULL", :order => "position ASC", :include => [:parts, :slugs, :children], :paging => false
  after_filter :expire_menu_fragment_caching, :only => [:create, :update, :destroy]

  def new
    @page = Page.new
    RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"]).each do |page_part|
      @page.parts << PagePart.new(:title => page_part)
    end
  end

protected
  def expire_menu_fragment_caching
    expire_fragment(%r{site_menu})
  end

end
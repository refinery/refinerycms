class Admin::PagesController < Admin::BaseController

  crudify :page, :conditions => "parent_id IS NULL", :order => "position ASC", :include => [:parts, :slugs, :children], :paging => false
  before_filter :find_pages_for_parents_list, :only => [:new, :create, :edit, :update]
  after_filter :expire_menu_fragment_caching, :only => [:create, :update, :destroy, :update_positions]

  def new
    @page = Page.new
    RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"]).each do |page_part|
      @page.parts << PagePart.new(:title => page_part)
    end
  end

protected
  def expire_menu_fragment_caching
    expire_fragment(%r{#{RefinerySetting.find_or_set(:refinery_menu_cache_action_suffix, "site_menu")}})
  end

  # This finds all of the pages that could possibly be assigned as the current page's parent.
  def find_pages_for_parents_list
    @pages_for_parents_list = []
    Page.find_all_by_parent_id(nil, :order => "position ASC").each do |page|
      @pages_for_parents_list << page
      @pages_for_parents_list += add_pages_branch_to_parents_list(page)
    end
    @pages_for_parents_list.flatten.compact!
    # We need to remove all references to the current page or any of its decendants or we get a nightmare.
    unless @page.nil? or @page.new_record?
      @pages_for_parents_list.reject! do |page|
        page.id == @page.id or @page.descendants.include?(page)
      end
    end
  end

  def add_pages_branch_to_parents_list(page)
    list = []
    page.children.each do |child|
      list << child
      list += add_pages_branch_to_parents_list(child) if child.children.any?
    end
    list
  end

end

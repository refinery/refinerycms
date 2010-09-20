class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def after_save(page)
    expire_caching(page)
  end

  def after_destroy(page)
    expire_caching(page)
  end

protected
  def expire_caching(page)
    expire_fragment %r{.*#{Refinery.base_cache_key}_?#{RefinerySetting.find_or_set(:refinery_menu_cache_action_suffix, "site_menu")}.*}
    expire_fragment %r{.*/pages/.*}
  end

end

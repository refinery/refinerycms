class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def after_create(page)
    expire_cache
  end

  def after_update(page)
    expire_cache
  end

  def after_destroy(page)
    expire_cache
  end

  protected
  def expire_cache
    # Delete the full Cache
    cache_root = File.join(page_cache_directory||'public',
                           'refinery_page_cache')
    if File.exists? cache_root
      FileUtils.rm_r cache_root.to_s
    end
  end
end
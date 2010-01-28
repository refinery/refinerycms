class NewsItemsController < ApplicationController

  before_filter :find_latest_news_items, :find_page
  before_filter :find_news_item, :only => [:show]

protected

  def find_latest_news_items
    @news_items = NewsItem.latest
  end

  def find_news_item
    @news_item = NewsItem.find(params[:id], :conditions => ["publish_date < ?", Time.now])
  end

  def find_page
    @page = Page.find_by_link_url("/news", :include => [:parts, :slugs])
  end

end
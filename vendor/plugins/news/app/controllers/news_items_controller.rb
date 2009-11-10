class NewsItemsController < ApplicationController

  before_filter :get_latest_posts
  before_filter :load_page, :only => [:index, :show]

  def index
    respond_to do |wants|
      wants.html
    end
  end

  def show
    @news_item = NewsItem.find(params[:id], :conditions => ["publish_date < ?", Time.now])
    respond_to do |wants|
     wants.html
    end
  end

protected

  def get_latest_posts
    @news_items = NewsItem.latest
  end

  def load_page
    @page = Page.find_by_link_url("/news", :include => [:parts, :slugs])
  end

end
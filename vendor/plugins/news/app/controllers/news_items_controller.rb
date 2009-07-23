class NewsItemsController < ApplicationController
  
  before_filter :get_latest_posts
  before_filter :load_page, :only => [:index, :show]
  
	def show
	  @news_item = NewsItem.find(params[:id], :conditions => ["publish_date < ?", Time.now])
	end

protected

  def get_latest_posts
    @news_items = NewsItem.latest
  end

  def load_page
    @page = Page.find_by_link_url("/news")
  end
  
end
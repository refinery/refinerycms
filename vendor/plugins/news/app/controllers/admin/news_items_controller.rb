class Admin::NewsItemsController < Admin::BaseController

  crudify :news_item, :order => "created_at DESC"

end

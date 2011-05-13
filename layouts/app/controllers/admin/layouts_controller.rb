module Admin
  class LayoutsController < Admin::BaseController

    crudify :layout,
            :title_attribute => 'template_name', :xhr_paging => true

  end
end

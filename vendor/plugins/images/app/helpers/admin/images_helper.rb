module Admin::ImagesHelper
	
	def image_views
		RefinerySetting.find_or_set(:image_views, [:grid, :list])
	end

	def current_image_view
	  RefinerySetting.find_or_set(:preferred_image_view, :list)
	end

	def change_list_mode_if_specified
	  unless params[:action] != "index" or params[:view].blank? or !image_views.include? params[:view].to_sym
	    RefinerySetting[:preferred_image_view] = params[:view]
	  end
	end
	
end
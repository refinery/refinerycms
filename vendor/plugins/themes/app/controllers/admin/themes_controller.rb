class Admin::ResourcesController < Admin::BaseController

  crudify :theme, :order => "updated_at DESC"
	
	# allows the user to both select a theme on the index page
	# and upload a zip file (new/create/update) which saves the unzipped version of it
	
end
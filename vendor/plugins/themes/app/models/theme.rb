require 'zip/zip'
require 'zip/zipfilesystem'

class Theme < ActiveRecord::Base

	before_save :read_theme

  has_attachment :storage => :file_system,
          :size => 0.kilobytes..10.megabytes,
          :path_prefix => 'themes',
					:content_type => 'application/zip'
	
	# Once a zip is uploaded it unzips it into the themes directory
	def after_attachment_saved
		# set title from zip file name. strip underscores
		title = "testtheme"
		
	  Zip::ZipFile.open(self.path).each do |single_file|
	    single_file.extract(File.join(RAILS_ROOT, "themes", title, single_file.name))
	  end
	end
	
	def preview_image
		# returns the preview.png
	end
	
	def read_theme
		# description - README file contents
		# licence - LICENCE file contents
	end
	
end
require 'zip/zip'
require 'zip/zipfilesystem'

class Theme < ActiveRecord::Base

	before_save :read_theme

  has_attachment :storage => :file_system,
          :size => 0.kilobytes..15.megabytes,
					:content_type => 'application/zip'
	
	# Once a zip is uploaded it unzips it into the themes directory
	def after_attachment_saved
		# make the folder for the them
		FileUtils.mkdir(self.theme_path) unless File.exists?(self.theme_path)
		
		# extracts the contents of the zip file into the theme directory
	 	Zip::ZipFile.foreach(self.filename) do |entry|
			FileUtils.mkdir_p(File.dirname("#{theme_path}/#{entry}"))
			entry.extract("#{theme_path}/#{entry}") { true }
	  end
	end
	
	def theme_folder_title
		File.basename(self.filename).split(".").first
	end
	
	def theme_path
		File.join(RAILS_ROOT, "themes", theme_folder_title)
	end
	
	def preview_image
		File.join(theme_path, "preview.png")
	end
	
	def read_theme
		self.title = File.basename(self.filename).split(".").first.titleize
		
		if File.exists?(File.join(theme_path, "LICENSE"))
			self.license =  File.open(File.join(theme_path, "LICENSE")).read
		end
		
		if File.exists?(File.join(theme_path, "README"))		
			self.description =  File.open(File.join(theme_path, "README")).read
		end
	end
	
end
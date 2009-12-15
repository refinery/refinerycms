require 'zip/zip'
require 'zip/zipfilesystem'

class Theme < ActiveRecord::Base

  has_attachment :storage => :file_system,
          :size => 0.kilobytes..10.megabytes,
          :path_prefix => 'themes',
					:content_type => 'application/zip'
	
	# Once a zip is uploaded it unzips it into the themes directory
	def after_attachment_saved
	  Zip::ZipFile.open(self.path).each do |single_file|
	    single_file.extract(File.join(RAILS_ROOT, "themes", single_file.name)
	  end
	end
	
end
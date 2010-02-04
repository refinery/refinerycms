class Image < ActiveRecord::Base
	
	# Docs for attachment_fu http://github.com/technoweenie/attachment_fu
  has_attachment :content_type => :image,
                 :storage => (USE_S3_BACKEND ? :s3 : :file_system),
                 :path_prefix => (USE_S3_BACKEND ? nil : 'public/system/images'),
                 :processor => 'Rmagick',
                 :thumbnails => ((((thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})).is_a?(Hash) ? thumbnails : (RefinerySetting[:image_thumbnails] = {}))) rescue {}),
                 :max_size => 50.megabytes
								
  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title],
          				:index_file => [RAILS_ROOT,"tmp","index"]

	named_scope :thumbnails, :conditions => "parent_id NOT NULL"
	named_scope :originals, :conditions => {:parent_id => nil}
	
	# when a dialog pops up with images, how many images per page should there be
	PAGES_PER_DIALOG = 18
	
	# when listing images out in the admin area, how many images should show per page
	PAGES_PER_ADMIN_INDEX = 20
	
	validates_as_attachment
	
	# Returns a titleized version of the filename
	# my_file.jpg returns My File
  def title
    self.filename.gsub(/\.\w+$/, '').titleize
  end
	
	# How many images per page should be displayed?
  def self.per_page(dialog = false)
    dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
  end

end
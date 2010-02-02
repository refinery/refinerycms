class Image < ActiveRecord::Base
	
	# Docs for attachment_fu http://github.com/technoweenie/attachment_fu
  has_attachment :content_type => :image,
                 :storage => (USE_S3_BACKEND ? :s3 : :file_system),
                 :path_prefix => (USE_S3_BACKEND ? nil : 'public/system/images'),
                 :processor => 'Rmagick',
                 :thumbnails => ((((thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})).is_a?(Hash) ? thumbnails : (RefinerySetting[:image_thumbnails] = {}))) rescue {}),
                 :max_size => 5.megabytes
								
  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title],
          				:index_file => [RAILS_ROOT,"tmp","index"]

	named_scope :thumbnails, :conditions => "parent_id NOT NULL"
	named_scope :originals, :conditions => {:parent_id => nil}
	
	# when a dialog pops up with images, how many images per page should there be
	PAGES_PER_DIALOG = 18
	
	# when listing images out in the admin area, how many images should show per page
	PAGES_PER_ADMIN_INDEX = 20
	
	# Custom validation method to validate attachments.
	# TODO: Why aren't we using the validates_as_attachment method?
  def validate
   errors.add_to_base("You must choose a file to upload") unless self.filename

   unless self.filename.nil?
     [:size].each do |attr_name|
       enum = attachment_options[attr_name]

       errors.add_to_base("Files should be smaller than 50 MB in size") unless enum.nil? || enum.include?(send(attr_name))
     end
   end
  end
	
	# Returns a titleized version of the filename
	# my_file.jpg returns My File
  def title
    self.filename.gsub(/\.\w+$/, '').titleize
  end
	
	# How many images per page should be displayed?
  def self.per_page(dialog = false)
    dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
  end
	
	# 
  def self.last_page(images, dialog=false)
    page = unless images.size <= self.per_page(dialog)
      (images.size / self.per_page(dialog).to_f).ceil
    else
      nil # this must be nil, it can't be 0 as there apparently isn't a 0th page.
    end
  end

end
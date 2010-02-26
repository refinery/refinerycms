class Image < ActiveRecord::Base

  # What is the max image size a user can upload
  MAX_SIZE_IN_MB = 20

  # Docs for attachment_fu http://github.com/technoweenie/attachment_fu
  has_attachment :content_type => :image,
                 :storage => (USE_S3_BACKEND ? :s3 : :file_system),
                 :path_prefix => (USE_S3_BACKEND ? nil : 'public/system/images'),
                 :processor => 'Rmagick',
                 :thumbnails => ((((thumbnails = RefinerySetting.find_or_set(:image_thumbnails, {})).is_a?(Hash) ? thumbnails : (RefinerySetting[:image_thumbnails] = {}))) rescue {}),
                 :max_size => MAX_SIZE_IN_MB.megabytes

  # we could use validates_as_attachment but it produces 4 odd errors like
  # "size is not in list". So we basically here enforce the same validation
  # rules here except display the error messages we want
  # This is a known problem when using attachment_fu
  def validate
    if self.filename.nil?
      errors.add_to_base("You must choose an image to upload")
    else
      [:size, :content_type].each do |attr_name|
        enum = attachment_options[attr_name]

        unless enum.nil? || enum.include?(send(attr_name))
          errors.add_to_base("Images should be smaller than #{MAX_SIZE_IN_MB} MB in size") if attr_name == :size
          errors.add_to_base("Your image must be either a JPG, PNG or GIF") if attr_name == :content_type
        end
      end
    end
  end

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  named_scope :thumbnails, :conditions => "parent_id IS NOT NULL"
  named_scope :originals, :conditions => {:parent_id => nil}

  # when a dialog pops up with images, how many images per page should there be
  PAGES_PER_DIALOG = 18

  # when listing images out in the admin area, how many images should show per page
  PAGES_PER_ADMIN_INDEX = 20

  # How many images per page should be displayed?
  def self.per_page(dialog = false)
    dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
  end

  # Returns a titleized version of the filename
  # my_file.jpg returns My File
  def title
    CGI::unescape(self.filename).gsub(/\.\w+$/, '').titleize
  end

end

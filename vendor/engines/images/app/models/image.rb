class Image < ActiveRecord::Base

  # What is the max image size a user can upload
  MAX_SIZE_IN_MB = 20

  image_accessor :image

  validates_presence_of   :image,
                          :message => 'You must choose an image to upload'
  validates_size_of       :image, :maximum => MAX_SIZE_IN_MB.megabytes,
                          :message => "Images should be smaller than #{MAX_SIZE_IN_MB} MB in size"
  validates_mime_type_of  :image, :in => %w(image/jpeg image/png image/gif),
                          :message => 'Your image must be either a JPG, PNG or GIF'

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  # when a dialog pops up with images, how many images per page should there be
  PAGES_PER_DIALOG = 18

  # when listing images out in the admin area, how many images should show per page
  PAGES_PER_ADMIN_INDEX = 20

  delegate :size, :mime_type, :url, :width, :height, :to => :image

  # How many images per page should be displayed?
  def self.per_page(dialog = false)
    dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
  end

  # Returns a titleized version of the filename
  # my_file.jpg returns My File
  def title
    CGI::unescape(self.image_name).gsub(/\.\w+$/, '').titleize
  end

end

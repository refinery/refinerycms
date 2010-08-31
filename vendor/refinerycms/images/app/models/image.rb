class Image < ActiveRecord::Base

  # What is the max image size a user can upload
  MAX_SIZE_IN_MB = 20

  image_accessor :image

  validates :image, :presence  => { :message => ::I18n.t('image_specify_for_upload') },
                    :length    => { :maximum => MAX_SIZE_IN_MB.megabytes,
                                    :message => ::I18n.t('image_should_be_smaller_than_max_image_size',
                                                       :max_image_size => MAX_SIZE_IN_MB.megabytes) }
  validates_property :mime_type, :of => :image, :in => %w(image/jpeg image/png image/gif),
                     :message => ::I18n.t('image_must_be_these_formats')

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title]

  # when a dialog pops up with images, how many images per page should there be
  PAGES_PER_DIALOG = 18

  # when a dialog pops up with images, but that dialog has image resize options
  # how many images per page should there be
  PAGES_PER_DIALOG_THAT_HAS_SIZE_OPTIONS = 12

  # when listing images out in the admin area, how many images should show per page
  PAGES_PER_ADMIN_INDEX = 20

  delegate :size, :mime_type, :url, :width, :height, :to => :image

  class << self
    # How many images per page should be displayed?
    def per_page(dialog = false, has_size_options = false)
      if dialog
        unless has_size_options
          PAGES_PER_DIALOG
        else
          PAGES_PER_DIALOG_THAT_HAS_SIZE_OPTIONS
        end
      else
        PAGES_PER_ADMIN_INDEX
      end
    end
  end

  # Get a thumbnail job object given a geometry.
  def thumbnail(geometry = nil)
    if geometry.is_a?(Symbol)
      if (sizes = RefinerySetting.find_or_set(:image_thumbnails, {})) and sizes.keys.include?(geometry)
        geometry = sizes[geometry].presence
      end
    end

    if geometry.present? && !geometry.is_a?(Symbol)
      self.image.thumb(geometry)
    else
      self.image
    end
  end

  # Returns a titleized version of the filename
  # my_file.jpg returns My File
  def title
    CGI::unescape(self.image_name).gsub(/\.\w+$/, '').titleize
  end

end

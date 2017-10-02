require 'dragonfly'

module Refinery
  class Image < Refinery::Core::BaseModel
    translates :image_title, :image_alt

    attribute :image_title
    attribute :image_alt

    dragonfly_accessor :image, :app => :refinery_images

    include Images::Validators

    validates :image, :presence  => true
    validates_with ImageSizeValidator
    validates_with ImageUpdateValidator, :on => :update
    validates_property :mime_type,
                       :of => :image,
                       :in => ::Refinery::Images.whitelisted_mime_types,
                       :message => :incorrect_format

    delegate :size, :mime_type, :url, :width, :height, :to => :image

    class << self
      # How many images per page should be displayed?
      def per_page(dialog = false, has_size_options = false)
        if dialog
          if has_size_options
            Images.pages_per_dialog_that_have_size_options
          else
            Images.pages_per_dialog
          end
        else
          Images.pages_per_admin_index
        end
      end
    end

    # Get a thumbnail job object given a geometry and whether to strip image profiles and comments.
    def thumbnail(options = {})
      options = { :geometry => nil, :strip => false }.merge(options)
      geometry = convert_to_geometry(options[:geometry])
      thumbnail = image
      thumbnail = thumbnail.thumb(geometry) if geometry
      thumbnail = thumbnail.strip if options[:strip]
      thumbnail
    end

    # Intelligently works out dimensions for a thumbnail of this image based on the Dragonfly geometry string.
    def thumbnail_dimensions(geometry)
      dimensions = ThumbnailDimensions.new(geometry, image.width, image.height)
      { :width => dimensions.width, :height => dimensions.height }
    end

    # Returns a titleized version of the filename
    # my_file.jpg returns My File

    def title
      image_title.presence || CGI::unescape(image_name.to_s).gsub(/\.\w+$/, '').titleize
    end

    def alt
      image_alt.presence || title
    end

    private

    def convert_to_geometry(geometry)
      if geometry.is_a?(Symbol) && Refinery::Images.user_image_sizes.keys.include?(geometry)
        Refinery::Images.user_image_sizes[geometry]
      else
        geometry
      end
    end

  end
end

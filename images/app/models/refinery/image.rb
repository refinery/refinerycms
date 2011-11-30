module Refinery
  class Image < ActiveRecord::Base
    include Images::Validators

    image_accessor :image

    validates :image, :presence  => true
    validates_with ImageSizeValidator
    validates_property :mime_type, :of => :image, :in => %w(image/jpeg image/png image/gif image/tiff),
                       :message => :incorrect_format

    # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
    acts_as_indexed :fields => [:title]

    # allows Mass-Assignment
    attr_accessible :id, :image, :image_size, :alt

    delegate :size, :mime_type, :url, :width, :height, :to => :image

    class << self
      # How many images per page should be displayed?
      def per_page(dialog = false, has_size_options = false)
        if dialog
          unless has_size_options
            Images.pages_per_dialog
          else
            Images.pages_per_dialog_that_have_size_options
          end
        else
          Images.pages_per_admin_index
        end
      end

      def user_image_sizes
        ::Refinery::Setting.find_or_set(:user_image_sizes, {
          :small => '110x110>',
          :medium => '225x255>',
          :large => '450x450>'
        }, :destroyable => false)
      end
    end

    # Get a thumbnail job object given a geometry.
    def thumbnail(geometry = nil)
      if geometry.is_a?(Symbol) and self.class.user_image_sizes.keys.include?(geometry)
        geometry = self.class.user_image_sizes[geometry]
      end

      if geometry.present? && !geometry.is_a?(Symbol)
        image.thumb(geometry)
      else
        image
      end
    end

    # Intelligently works out dimensions for a thumbnail of this image based on the Dragonfly geometry string.
    def thumbnail_dimensions(geometry)
      geometry = geometry.to_s
      width = original_width = self.image_width.to_f
      height = original_height = self.image_height.to_f
      geometry_width, geometry_height = geometry.to_s.split(%r{\#{1,2}|\+|>|!|x}im)[0..1].map(&:to_f)
      if (original_width * original_height > 0) && geometry =~ ::Dragonfly::ImageMagick::Processor::THUMB_GEOMETRY
        if geometry =~ ::Dragonfly::ImageMagick::Processor::RESIZE_GEOMETRY
          if geometry !~ %r{\d+x\d+>} || (geometry =~ %r{\d+x\d+>} && (width > geometry_width.to_f || height > geometry_height.to_f))
            # Try scaling with width factor first. (wf = width factor)
            wf_width = (original_width * (geometry_width / width)).ceil
            wf_height = (original_height * (geometry_width / width)).ceil

            # Scale with height factor (hf = height factor)
            hf_width = (original_width * (geometry_height / height)).ceil
            hf_height = (original_height * (geometry_height / height)).ceil

            # Take the highest value that doesn't exceed either axis limit.
            use_wf = wf_width <= geometry_width && wf_height <= geometry_height
            if use_wf && hf_width <= geometry_width && hf_height <= geometry_height
              use_wf = wf_width * wf_height > hf_width * hf_height
            end

            if use_wf
              width = wf_width
              height = wf_height
            else
              width = hf_width
              height = hf_height
            end
          end
        else
          # cropping
          width = geometry_width
          height = geometry_height
        end
      end

      { :width => width.to_i, :height => height.to_i }
    end

    # If the image has alt text, return that. Otherwise, return a titleized
    # version of the filename, ie, my_file.jpg returns My File
    def title
      alt.presence || CGI::unescape(image_name.to_s).gsub(/\.\w+$/, '').titleize
    end

  end
end

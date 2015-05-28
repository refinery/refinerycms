module Refinery
  class ThumbnailDimensions

    attr_accessor :width, :height, :geometry, :original_width, :original_height

    def initialize(geometry, original_width, original_height)
      @geometry = Geometry.new(geometry)

      @original_width = original_width.to_f
      @original_height = original_height.to_f

      process
    end

    def process
      if valid_geometry && resize_geometry && resize_necessary
        scale
      elsif valid_geometry && !resize_geometry
        crop
      else
        original_dimensions
      end
    end

    def valid_geometry
      (original_width * original_height > 0) && thumb_geometry === geometry.geometry
    end

    def resize_geometry
      ::Dragonfly::ImageMagick::Processors::Thumb::RESIZE_GEOMETRY === geometry.geometry
    end

    def resize_necessary
      !geometry.custom? ||
          (geometry.custom? &&
            (original_width > geometry.width ||
              original_height > geometry.height))
    end

    def original_dimensions
      @width = original_width
      @height = original_height
    end

    def crop
      @width = geometry.width
      @height = geometry.height
    end

    def scale
      # Try scaling with width factor first. (wf = width factor)
      wf_width = geometry.width.round
      wf_height = (original_height * geometry.width / original_width).round

      # Scale with height factor (hf = height factor)
      hf_width = (original_width * geometry.height / original_height).round
      hf_height = geometry.height.round

      # Take the highest value that doesn't exceed either axis limit.
      use_wf = wf_width > 0 && wf_width <= geometry.width && wf_height <= geometry.height
      if use_wf && hf_width <= geometry.width && hf_height <= geometry.height
        use_wf = wf_width * wf_height > hf_width * hf_height
      end

      if use_wf
        @width = wf_width
        @height = wf_height
      else
        @width = hf_width
        @height = hf_height
      end
    end

    def thumb_geometry
      Regexp.union(::Dragonfly::ImageMagick::Processors::Thumb::RESIZE_GEOMETRY,
                   ::Dragonfly::ImageMagick::Processors::Thumb::CROPPED_RESIZE_GEOMETRY,
                   ::Dragonfly::ImageMagick::Processors::Thumb::CROP_GEOMETRY)
    end

    class Geometry
      attr_reader :geometry, :height, :width
      def initialize(geometry)
        @geometry = if geometry.is_a?(Symbol) && Refinery::Images.user_image_sizes.keys.include?(geometry)
          Refinery::Images.user_image_sizes[geometry]
        else
          geometry.to_s
        end

        @width, @height = @geometry.split(%r{\#{1,2}|\+|>|!|x}im)[0..1].map(&:to_f)
      end

      def custom?
        %r{\d+x\d+>} === geometry
      end
    end
  end
end

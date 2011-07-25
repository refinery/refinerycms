module Refinery
  module Helpers
    module ImageHelper

      # replace all system images with a thumbnail version of them (handy for all images inside a page part)
      # for example, <%= content_fu(@page[:body], '96x96#c') %> converts all /system/images to a 96x96 cropped thumbnail
      def content_fu(content, thumbnail)
        content.gsub(%r{<img.+?src=['"](/system/images/.+?)/.+?/>}) do |image_match|
           begin
             uid = Dragonfly::Job.from_path(
                      "#{image_match.match(%r{(/system/images/.+?)/})[1]}", Dragonfly[:images]
                   ).uid

             image_fu Image.where(:image_uid => uid).first, thumbnail
           rescue
             # FAIL, don't care why but return what we found initially.
             image_match
           end
         end
      end

      # image_fu is a helper for inserting an image that has been uploaded into a template.
      # Say for example that we had a @model.image (@model having a belongs_to :image relationship)
      # and we wanted to display a thumbnail cropped to 200x200 then we can use image_fu like this:
      # <%= image_fu @model.image, '200x200' %> or with no thumbnail: <%= image_fu @model.image %>
      def image_fu(image, geometry = nil, options={})
        if image.present?
          original_width = image.image_width
          original_height = image.image_height

          new_width, new_height = image_dimensions_for_geometry(image, geometry) if geometry

          image_tag(image.thumbnail(geometry).url, {
            :alt => image.respond_to?(:title) ? image.title : image.image_name,
            :width => new_width,
            :height => new_height
          }.merge(options))
        end
      end

      def image_dimensions_for_geometry(image, geometry)
        geometry = geometry.to_s
        aspect_ratio = nil
        width = image.image_width.to_f
        height = image.image_height.to_f
        geometry_width, geometry_height = geometry.to_s.split(%r{\#{1,2}|\+|>|!|x}im)[0..1].map(&:to_f)
        if (width * height > 0) && geometry =~ ::Dragonfly::ImageMagick::Processor::THUMB_GEOMETRY
          if geometry =~ ::Dragonfly::ImageMagick::Processor::RESIZE_GEOMETRY
            if geometry !~ %r{\d+x\d+>} || (geometry =~ %r{\d+x\d+>} && (width > geometry_width.to_f || height > geometry_height.to_f))
              if geometry_width > geometry_height
                width = if (aspect = (width / height)) >= 1
                  geometry_height * aspect
                else
                  geometry_height / aspect
                end
                height = geometry_height
              else
                height = if (aspect = (height / width)) >= 1
                  geometry_width * aspect
                else
                  geometry_width / aspect
                end
                width = geometry_width
              end
            end
          else
            # cropping
            width = geometry_width
            height = geometry_height
          end
        end

        [width.to_i, height.to_i]
      end
    end
  end
end

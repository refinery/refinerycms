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
          aspect_ratio = original_width / original_height
          
          if !geometry.nil? and geometry.match(/#$/)
            new_width = geometry.split('x').first
            new_height = geometry.split('x').last
          elsif !geometry.nil?
            new_width = geometry.split('x').first
            new_height = geometry.split('x').last
            new_aspect_ratio = width / height
          else
            new_width = original_width
            new_height = original_height
          end
          generated_image = image.thumbnail(geometry)
          image_tag(generated_image.url, {
            :alt => image.respond_to?(:title) ? image.title : image.image_name,
            :width => new_width,
            :height => new_height
          }.merge(options))
        end
      end

    end
  end
end

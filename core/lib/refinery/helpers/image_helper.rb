module Refinery
  module Helpers
    module ImageHelper

      # replace all system images with a thumbnail version of them (handy for all images inside a page part)
      # for example, <%= content_fu(@page.content_for(:body), '96x96#c') %> converts all /system/images to a 96x96 cropped thumbnail
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
          # call rails' image tag function with default alt tag.
          # if any other options were supplied these are merged in and can replace the defaults.
          # if the geomtry is nil, then we know the image height and width already.
          # detect nil geometry or cropping presence which is where we can guess the dimensions
          unless geometry.nil? or !(split_geometry = geometry.to_s.split('#')).many? or !(split_geometry = split_geometry.first.split('x')).many?
            image_width, image_height = split_geometry
          else
            image_width = nil
            image_height = nil
          end

          image_tag(image.thumbnail(geometry).url, {
            :alt => image.respond_to?(:title) ? image.title : image.image_name,
            :width => image_width,
            :height => image_height
          }.merge(options))
        end
      end

    end
  end
end

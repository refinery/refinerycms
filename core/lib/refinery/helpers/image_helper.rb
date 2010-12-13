module Refinery
  module Helpers
    module ImageHelper

      # replace all system images with a thumbnail version of them (handy for all images inside a page part)
      # for example, <%= content_fu(@page[:body], '96x96#c') %> converts all /system/images to a 96x96 cropped thumbnail
      def content_fu(content, thumbnail)
        raise NotImplementedError # todo: implement for new syntax.

        content.scan(/\/system\/images([^\"\ ]*)/).flatten.each do |match|
          parts = match.split(".")
          extension = parts.pop
          content.gsub!(match, "#{parts.join(".")}_#{thumbnail}.#{extension}")
        end unless content.blank?

        return content
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
          image_tag(image.thumbnail(geometry).url, {
            :alt => image.respond_to?(:title) ? image.title : image.image_name,
            :width => (image.image_width if geometry.nil?),
            :height => (image.image_height if geometry.nil?)
          }.merge(options))
        end
      end

    end
  end
end

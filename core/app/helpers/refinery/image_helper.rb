module Refinery
  module ImageHelper

    # replace all system images with a thumbnail version of them (handy for all images inside a page part)
    # for example, <%= content_fu(@page.content_for(:body), '96x96#c') %> converts all /system/images to a 96x96 cropped thumbnail
    def content_fu(content, thumbnail)
      content.gsub(%r{<img.+?src=['"](/system/images/.+?)/.+?/>}) do |img|
        begin
          sha = img.match(%r{/system/images/(.+?)/})[1]
          job = Dragonfly::Job.deserialize sha, Dragonfly.app(:refinery_images)

          image_fu Image.where(:image_uid => job.uid).first, thumbnail
        rescue Dragonfly::Serializer::BadString
          img
        end
      end
    end

    # image_fu is a helper for inserting an image that has been uploaded into a template.
    # Say for example that we had a @model.image (@model having a belongs_to :image relationship)
    # and we wanted to display a thumbnail cropped to 200x200 then we can use image_fu like this:
    # <%= image_fu @model.image, '200x200' %> or with no thumbnail: <%= image_fu @model.image %>
    def image_fu(image, geometry = nil, options = {})
      return nil if image.blank?

      thumbnail_args = options.slice(:strip)
      thumbnail_args[:geometry] = geometry if geometry

      image_tag_args = (image.thumbnail_dimensions(geometry) rescue {})
      image_tag_args[:alt] = image.respond_to?(:title) ? image.title : image.image_name

      image_tag(image.thumbnail(thumbnail_args).url, image_tag_args.merge(options))
    end
  end
end

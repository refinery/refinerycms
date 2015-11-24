module Glass
  module MiscHelper
    # def glass_image_fu(image_uid, geometry = nil, options={})
    #   image_tag(::Dragonfly[:refinery_images].fetch(image_uid).thumb(geometry).url, options)
    # end

    def glass_img_src(image_uid, geometry = nil)
      # This has a few advantages (that we don't seem to need at the moment)
      #  1. Can resize and crop images
      #  2. All images are hosted from a single domain (may be an issue with https??)
      img = Dragonfly.app(:refinery_images).fetch(image_uid)
      img = img.thumb(geometry) if geometry.present?
      return img.url(:name => File.basename(image_uid))

      # This was just serving up the S3 url directly for a while
      # Dragonfly.app(:refinery_images).remote_url_for(image_uid)
    end

    def glass_vid_src(vid_uid)
      return "/system/refinery/videos/#{vid_uid}"
    end
  end
end

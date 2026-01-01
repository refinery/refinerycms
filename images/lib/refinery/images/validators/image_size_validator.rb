# frozen_string_literal: true

module Refinery
  module Images
    module Validators
      class ImageSizeValidator < ActiveModel::Validator
        def validate(record)
          record.errors.add(:image, ::I18n.t('too_big',
                                             scope: 'activerecord.errors.models.refinery/image',
                                             size: Images.max_image_size)) if too_big(record.image)
        end

        private def too_big(image)
          image.respond_to?(:length) && image.length > Images.max_image_size
        end
      end
    end
  end
end

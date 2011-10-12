module Refinery
  module Images
    module Validators
      class ImageSizeValidator < ActiveModel::Validator

        def validate(record)
          if record.image.length > Images.max_image_size
            record.errors[:image] << ::I18n.t('too_big',
                                             :scope => 'activerecord.errors.models.refinery/image',
                                             :size => Images.max_image_size)
          end
        end

      end
    end
  end
end

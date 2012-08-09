module Refinery
  module Images
    module Validators
      class ImageUpdateValidator < ActiveModel::Validator

        def validate(record)
          if record.image_name_changed?
            record.errors.add :image_name,
              ::I18n.t("different_file_name",
                       :scope => "activerecord.errors.models.refinery/image")
          end
        end

      end
    end
  end
end

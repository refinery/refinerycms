module Refinery
  module Resources
    module Validators
      class FileSizeValidator < ActiveModel::Validator

        def validate(record)
          if record.file.length > Resources::Options.max_file_size
            record.errors[:file] << ::I18n.t('too_big',
                                             :scope => 'activerecord.errors.models.refinery/resource',
                                             :size => Resources::Options.max_file_size)
          end
        end

      end
    end
  end
end

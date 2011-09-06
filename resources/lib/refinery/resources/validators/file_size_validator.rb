module Refinery
  module Resources
    module Validators
      class FileSizeValidator < ActiveModel::Validator
      
        def validate(record)
          if record.file.length > Refinery::Resources.max_client_body_size
            record.errors[:file] << ::I18n.t('too_big', 
                                             :scope => 'activerecord.errors.models.refinery/resource',
                                             :size => Refinery::Resources.max_client_body_size)
          end
        end
      
      end
    end
  end
end
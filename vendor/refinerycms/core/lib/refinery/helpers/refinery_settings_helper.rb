module Refinery
  module Helpers
    module RefinerySettingsHelper
      def form_value_type
        return @refinery_setting && @refinery_setting.form_value_type.present? ? @refinery_setting.form_value_type : 'text_area'
      end
      
      def refinery_setting_value(setting)
        if setting.form_value_type == 'check_box'
          return setting.value == 1 ? 'true' : 'false'
        else
          return setting.value.to_s
        end
      end
    end
  end
end
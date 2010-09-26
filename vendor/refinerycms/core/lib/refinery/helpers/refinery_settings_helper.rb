module Refinery
  module Helpers
    module RefinerySettingsHelper
      def form_value_type
        return @refinery_setting && @refinery_setting.form_value_type.present? ? @refinery_setting.form_value_type : 'text_area'
      end
    end
  end
end
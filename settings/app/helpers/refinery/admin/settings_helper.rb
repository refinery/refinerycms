module ::Refinery
  module Admin
    module SettingsHelper
      def form_value_type
        @setting.form_value_type.presence || 'text_area'
      end

      def setting_title(f)
        if @setting.form_value_type == 'check_box'
          raw "<h3>#{@setting.name.to_s.titleize}?</h3>"
        else
          f.label :value
        end
      end

      def setting_field(f, help)
        case form_value_type
        when 'check_box'
          raw "#{f.check_box :value, :value => @setting.form_value}
               #{f.label :value, help.presence || t('enabled', :scope => 'refinery.admin.settings.form'),
                         :class => 'stripped'}"
        else
          f.text_area :value, :value => @setting.form_value,
                      :class => 'widest', :rows => 5
        end
      end
    end
  end
end

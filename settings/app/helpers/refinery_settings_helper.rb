module RefinerySettingsHelper
  def form_value_type
    @refinery_setting.form_value_type.presence || 'text_area'
  end

  def refinery_setting_title(f)
    if @refinery_setting.form_value_type == 'check_box'
      raw "<h3>#{@refinery_setting.name.to_s.titleize}?</h3>"
    else
      f.label :value
    end
  end

  def refinery_setting_field(f, help)
    case form_value_type
    when 'check_box'
      raw "#{f.check_box :value, :value => @refinery_setting.form_value}
           #{f.label :value, help.presence || t('enabled', :scope => 'admin.refinery_settings.form'),
                     :class => 'stripped'}"
    else
      f.text_area :value, :value => @refinery_setting.form_value,
                  :class => 'widest', :rows => 5
    end
  end
end

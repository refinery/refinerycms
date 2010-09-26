module RefinerySettingsHelper
  def form_value_type
    @refinery_setting.form_value_type.presence || 'text_area'
  end

  def refinery_setting_value(setting)
    if setting.form_value_type == 'check_box'
      return setting.value == 1 ? 'true' : 'false'
    else
      return setting.value.to_s
    end
  end
end
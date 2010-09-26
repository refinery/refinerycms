module RefinerySettingsHelper
  def form_value_type
    @refinery_setting.form_value_type.presence || 'text_area'
  end

  def refinery_setting_title(f)
    if @refinery_setting.form_value_type == 'check_box'
      "<h3>#{@refinery_setting.name.titleize}?</h3>".html_safe
    else
      f.label :value
    end
  end

  def refinery_setting_field(f, help)
    case form_value_type
    when 'check_box'
      "#{f.check_box :value, :value => @refinery_setting.form_value}
       #{f.label :value, help, :class => 'stripped'}".html_safe
    else
      f.text_area :value, :class => 'widest', :rows => 5
    end
  end

  def refinery_setting_value(setting)
    if setting.form_value_type == 'check_box'
      return setting.value == 1 ? 'true' : 'false'
    else
      return setting.value.to_s
    end
  end
end
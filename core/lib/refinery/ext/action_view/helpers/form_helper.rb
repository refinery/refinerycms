ActionView::Helpers::FormHelper.module_eval do

  def required_label(object_name, method, options = {})
    options = {:class => "required"}.merge!(options)

    label(object_name, method, "#{label_humanize_text(object_name, method, options)} *", options)
  end

  def label_humanize_text(object_name, method, options = {})
    object = options[:object]

    if object.respond_to?(:to_model)
      key = object.class.model_name.i18n_key
      i18n_default = ["#{key}.#{method}".to_sym, ""]
    end

    i18n_default ||= ""
    content = I18n.t("#{object_name}.#{method}", :default => i18n_default, :scope => "helpers.label").presence

    content ||= if object && object.class.respond_to?(:human_attribute_name)
      object.class.human_attribute_name(method)
    end

    content || method.humanize
  end

end

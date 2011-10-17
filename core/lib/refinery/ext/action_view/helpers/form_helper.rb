ActionView::Helpers::FormHelper.module_eval do

  def required_label(object_name, method, options = {})
    options = {:class => "required"}.merge!(options)

    label(object_name, method, "#{label_humanize_text(method, options)} *", options)
  end


  def label_humanize_text method, options = {}
    object = options[:object]

    content ||= if object && object.class.respond_to?(:human_attribute_name)
      object.class.human_attribute_name(method)
    end

    content ||= method.humanize
  end

end

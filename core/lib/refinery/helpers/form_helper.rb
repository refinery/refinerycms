require 'action_view'
require 'action_view/helpers'

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

ActionView::Helpers::FormBuilder.module_eval do

  def required_label(method, options = {})
    @template.required_label(@object_name, method, objectify_options(options))
  end

end

ActionView::Helpers::FormTagHelper.module_eval do

  def required_label_tag(name, text = nil, options = {})
    options = {:class => "required"}.merge!(options)
    text ||= "#{name.to_s.humanize} *"

    label_tag(name, text, options)
  end

end

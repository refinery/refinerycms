ActionView::Helpers::FormHelper.module_eval do

  def required_label(object_name, method, text = nil, options = {})
    options = {:class => "required"}.merge!(options)

    label(object_name, method, "#{label_humanize_text(object_name, method, text, options)} *", options)
  end


  def label_humanize_text object_name, method, text = nil, options = {}
    if text.blank?
      text = object_name.classify.constantize.respond_to?(:human_attribute_name) ? object_name.classify.constantize.human_attribute_name(method) : method.to_s
    else
      text = text.to_s
    end
    text.humanize
  end

end

ActionView::Helpers::FormBuilder.module_eval do

  def required_label(method, text = nil, options = {})
    @template.required_label(@object_name, method, text, objectify_options(options))
  end

end

ActionView::Helpers::FormTagHelper.module_eval do

  def required_label_tag(name, text = nil, options = {})
    options = {:class => "required"}.merge!(options)
    text ||= "#{name.to_s.humanize} *"

    label_tag(name, text, options)
  end

end


# I18n labels automatically
module ActionView
  module Helpers
    class InstanceTag
      def to_label_tag(text = nil, options = {})
        options = options.stringify_keys
        name_and_id = options.dup
        add_default_name_and_id(name_and_id)
        options.delete("index")
        options["for"] ||= name_and_id["id"]
        if text.blank?
          content = method_name.humanize
          if object.class.respond_to?(:human_attribute_name)
            content = object.class.human_attribute_name(method_name)
          end
        else
          content = text.to_s
        end
        label_tag(name_and_id["id"], content, options)
      end
    end
  end
end

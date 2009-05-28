ActionView::Helpers::FormHelper.module_eval do
	
	def required_label(object_name, method, text = nil, options = {})
		options = {:class => "required"}.merge!(options)
		text ||= "#{method.to_s.humanize} *"
		label(object_name, method, text, options)
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
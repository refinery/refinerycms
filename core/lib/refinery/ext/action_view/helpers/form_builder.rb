ActionView::Helpers::FormBuilder.module_eval do

  def required_label(method, options = {})
    @template.required_label(@object_name, method, objectify_options(options))
  end

end

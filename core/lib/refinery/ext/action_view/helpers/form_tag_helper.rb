ActionView::Helpers::FormTagHelper.module_eval do

  def required_label_tag(name, text = nil, options = {})
    options = {:class => "required"}.merge!(options)
    text ||= "#{name.to_s.humanize} *"

    label_tag(name, text, options)
  end

end

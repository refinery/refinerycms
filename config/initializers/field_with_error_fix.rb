ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  "<span class=\"fieldWithErrors\">#{html_tag}</span>"
end

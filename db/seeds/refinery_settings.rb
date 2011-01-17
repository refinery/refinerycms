[
  {:name => "site_name", :value => "Company Name"},
  {:name => "new_page_parts", :value => false, :form_type => 'check_box'},
  {:name => "activity_show_limit", :value => 7},
  {:name => "preferred_image_view", :value => :grid},
  {:name => "analytics_page_code", :value => "UA-xxxxxx-x"}
].each do |setting|
  RefinerySetting.create(:name => setting[:name].to_s, :value => setting[:value], :destroyable => false, :form_value_type => (setting[:form_type] || 'text_area'))
end

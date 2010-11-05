[
  {:name => "site_name", :value => "Company Name"},
  {:name => "new_page_parts", :value => false, :form_type => 'check_box'},
  {:name => "activity_show_limit", :value => 7},
  {:name => "preferred_image_view", :value => :grid},
  {:name => "analytics_page_code", :value => "UA-xxxxxx-x"},
  {:name => "user_image_sizes", :value => {
    :small => '110x110>',
    :medium => '225x255>',
    :large => '450x450>'
    }
  }
].each do |setting|
  RefinerySetting.create(:name => setting[:name].to_s, :value => setting[:value], :destroyable => false, :form_value_type => (setting[:form_type] || 'text_area'))
end

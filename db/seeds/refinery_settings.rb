[
  {:name => "site_name", :value => "Company Name", :form_type => 'text_field'},
  {:name => "new_page_parts", :value => false, :form_type => 'check_box'},
  {:name => "activity_show_limit", :value => 7, :form_type => 'text_field'},
  {:name => "preferred_image_view", :value => :grid, :form_type => 'text_area'},
  {:name => "analytics_page_code", :value => "UA-xxxxxx-x", :form_type => 'text_field'},
  # todo: remove these and use dragonfly better instead.
  {:name => "image_thumbnails", :value => {
    :small => '110x110>',
    :medium => '225x255>',
    :large => '450x450>'
    }, :form_type => 'text_area'
  }
].each do |setting|
  RefinerySetting.create(:name => setting[:name].to_s, :value => setting[:value], :destroyable => false, :form_value_type => setting[:form_type])
end

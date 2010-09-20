[
  {:name => "site_name", :value => "Company Name"},
  {:name => "new_page_parts", :value => false},
  {:name => "activity_show_limit", :value => 7},
  {:name => "preferred_image_view", :value => :grid},
  {:name => "analytics_page_code", :value => "UA-xxxxxx-x"},
  # todo: remove these and use dragonfly better instead.
  {:name => "image_thumbnails", :value => {
    :small => '110x110>',
    :medium => '225x255>',
    :large => '450x450>'
    }
  }
].each do |setting|
  RefinerySetting.create(:name => setting[:name].to_s, :value => setting[:value], :destroyable => false)
end

[
  {:name => "site_name", :value => "Company Name"},
  {:name => "new_page_parts", :value => false},
  {:name => "activity_show_limit", :value => 7},
  {:name => "preferred_image_view", :value => :grid},
  {:name => "analytics_page_code", :value => "UA-xxxxxx-x"},
  {:name => "theme", :value => "demolicious"},
  {:name => "image_thumbnails", :value => {
    :dialog_thumb => '106x106#c',
    :grid => '135x135#c',
    :small => '110x110>',
    :medium => '225x255>',
    :large => '450x450>',
    :preview => '96x96#c'
    }
  }
].each do |setting|
  RefinerySetting.create(:name => setting[:name].to_s, :value => setting[:value], :destroyable => false)
end

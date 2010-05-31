[
  {:name => "site_name", :value => "Company Name"},
  {:name => "new_page_parts", :value => false},
  {:name => "activity_show_limit", :value => 18},
  {:name => "preferred_image_view", :value => :grid},
  {:name => "analytics_page_code", :value => "UA-xxxxxx-x"},
  {:name => "theme", :value => "demolicious"},
  {:name => "image_thumbnails", :value => {
    :dialog_thumb => 'c106x106',
    :grid => 'c135x135',
    :thumb => '50x50>',
    :medium => '225x255>',
    :side_body => '300x500>',
    :preview => 'c96x96'
    }
  },
  {:name => 'refinery_i18n_locales', :value => {
      :en => 'English',
      :fr => 'Français',
      :nl => 'Nederlands',
      :'pt-BR' => 'Português',
      :da => 'Dansk',
      :nb => 'Norsk Bokmål',
      :sl => 'Slovenian'
    }
  }
].each do |setting|
  RefinerySetting.create(:name => setting[:name].to_s, :value => setting[:value], :destroyable => false)
end

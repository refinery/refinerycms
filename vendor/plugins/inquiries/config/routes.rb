ActionController::Routing::Routes.draw do |map|
  map.new_inquiry '/contact',
                  :controller => 'inquiries',
                  :action => 'new'

  map.thank_you_inquiries '/contact/thank_you',
                          :controller => 'inquiries',
                          :action => 'thank_you'

  map.resources :inquiries,
                :collection => {:thank_you => :get}

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :inquiries,
                    :collection => {:spam => :get},
                    :member => {:toggle_spam => :get}

    admin.resources :inquiry_settings
  end
end

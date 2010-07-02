Rails::Application.routes.draw do
  match '/contact', :to => 'inquiries#new', :as => 'new_inquiry'
  match '/contact/thank_you', :to => 'inquiries#thank_you', :as => 'thank_you_inquiries'
  resources :inquiries do
    collection do
      get :thank_you
    end
  end

  scope(:path => 'refinery', :name_prefix => 'admin', :module => 'admin') do
    resources :inquiries do
      collection do
        get :spam
      end
      member do
        get :toggle_spam
      end
    end
    resources :inquiry_settings
  end
end

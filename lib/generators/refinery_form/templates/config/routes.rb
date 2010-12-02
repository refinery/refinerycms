Refinery::Application.routes.draw do
  resources :<%= class_name.pluralize.underscore.downcase %>, :only => [:new, :create] do
    collection do
      get :thank_you
    end
  end

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :<%= class_name.pluralize.underscore.downcase %><% if @includes_spam %> do
      collection do
        get :spam
      end
      member do
        get :toggle_spam
      end
    end<% end %>
    resources :<%= singular_name %>_settings
  end
end

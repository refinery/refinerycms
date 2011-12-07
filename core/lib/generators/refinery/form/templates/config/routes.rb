Rails.application.routes.draw do
  scope(:module => :refinery/<%= class_name.pluralize.underscore.downcase %>, 
        :as => :refinery_<%= class_name.pluralize.underscore.downcase %>) do 
    resources :<%= class_name.pluralize.underscore.downcase %>, :only => [:new, :create] do
      collection do
        get :thank_you
    end
  end

  scope(:path => :refinery/<%= class_name.pluralize.underscore.downcase %>, 
        :as => :refinery_<%=class_name.pluralize.underscore.downcase %>_admin, 
        :module => :refinery/<%= class_name.pluralize.underscore.downcase %>/admin) do
    resources :<%= class_name.pluralize.underscore.downcase %>, :path => '' <% if @includes_spam %> do
      collection do
        get :spam
      end
      member do
        get :toggle_spam
      end
    end<% end %>
    resources :settings
  end
end

Refinery::Core::Engine.routes.draw do
  namespace :<%= class_name.pluralize.underscore.downcase %> do
    resources :<%= class_name.pluralize.underscore.downcase %>, :path => '', :only => [:new, :create] do
      collection do
        get :thank_you
      end
    end
  end

  namespace :admin, :path => 'refinery' do
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


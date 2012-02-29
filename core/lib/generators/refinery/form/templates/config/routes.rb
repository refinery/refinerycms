Refinery::Core::Engine.routes.draw do
  # Frontend routes
  namespace :<%= namespacing.underscore %> do
    resources :<%= class_name.pluralize.underscore.downcase %><%= ", :path => ''" if namespacing.underscore == class_name.pluralize.underscore.downcase %>, :path => '', :only => [:index, :show] do
      collection do
        get :thank_you
      end
    end
  end

  # Admin routes
  namespace :<%= namespacing.underscore %>, :path => '' do
    namespace :admin, :path => 'refinery<%= "/#{namespacing.underscore}" if namespacing.underscore != plural_name %>' do
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
end


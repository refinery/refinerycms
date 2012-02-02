Refinery::Core::Engine.routes.draw do
<% unless skip_frontend? %>
  # Frontend routes
  namespace :<%= namespacing.underscore %> do
    resources :<%= class_name.pluralize.underscore.downcase %>, :only => [:index, :show]
  end
<% end %>

  # Admin routes
  namespace :<%= namespacing.underscore %>, :path => '' do
    namespace :admin, :path => 'refinery/<%= namespacing.underscore %>' do
      resources :<%= class_name.pluralize.underscore.downcase %><%= ", :path => ''" if namespacing.underscore.pluralize == class_name.pluralize.underscore.downcase %>, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end
end

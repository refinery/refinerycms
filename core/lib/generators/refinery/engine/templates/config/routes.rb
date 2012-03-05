Refinery::Core::Engine.routes.append do
<% unless skip_frontend? %>
  # Frontend routes
  namespace :<%= namespacing.underscore %> do
    resources :<%= plural_name %><%= ", :path => ''" if namespacing.underscore == plural_name %>, :only => [:index, :show]
  end
<% end %>
  # Admin routes
  namespace :<%= namespacing.underscore %>, :path => '' do
    namespace :admin, :path => 'refinery<%= "/#{namespacing.underscore}" if namespacing.underscore != plural_name %>' do
      resources :<%= plural_name %>, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end

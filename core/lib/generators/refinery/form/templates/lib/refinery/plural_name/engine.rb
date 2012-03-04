module Refinery
  module <%= namespacing %>
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::<%= namespacing %>

      engine_name :refinery_<%= extension_plural_name %>

      initializer "register refinerycms_<%= plural_name %> plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= plural_name %>"
          plugin.url = Refinery::Core::Engine.routes.url_helpers.<%= namespacing.underscore %>_admin_<%= plural_name %>_path
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/<%= namespacing.underscore %>/<%= singular_name %>'<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
            :title => '<%= title.name %>'<% end %>
          }
          <% unless namespacing.underscore == plural_name -%>plugin.menu_match = %r{refinery/<%= namespacing.underscore %>/<%= plural_name %>(/.*)?$}<% end %>
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::<%= class_name.pluralize %>)
      end
    end
  end
end

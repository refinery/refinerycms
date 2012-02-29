module Refinery
  module <%= class_name.pluralize %><%= 'Engine' if plural_name == singular_name %>
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery::<%= class_name.pluralize %>
      engine_name :refinery_<%= plural_name %>

      config.after_initialize do
        Refinery.register_extension(Refinery::<%= class_name.pluralize %>)
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
          plugin.url = '/refinery/<%= plural_name %>'
          plugin.pathname = root
          plugin.activity = {
            :class_name => "Refinery::<%= class_name.pluralize %>::<%= class_name %>"<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
            :title => '<%= title.name %>'<% end %>
          }
        end
      end
    end
  end
end

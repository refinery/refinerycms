module Refinery
  module <%= class_name.pluralize %>
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::<%= class_name.pluralize %>

      engine_name :refinery_<%= plural_name %>

      initializer "register refinerycms_<%= plural_name %> plugin" do |app|
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
          plugin.url = {:controller => '/refinery/<%= plural_name %>'}
          plugin.pathname = root
          plugin.name = '<%= class_name.pluralize.underscore.downcase %>'
          plugin.url = '/refinery/<%= plural_name %>'

          plugin.activity = {
            :class_name => :'refinery/<%= plural_name%>/<%= singular_name %>'
          }
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::<%= class_name.pluralize %>)
      end
    end
  end
end

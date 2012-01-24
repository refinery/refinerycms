module Refinery
  module <%= namespacing %>
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::<%= namespacing %>

      engine_name :refinery_<%= engine_plural_name %>

      initializer "register refinerycms_<%= plural_name %> plugin" do |app|
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= plural_name %>"
          plugin.url = {
            :controller => 'refinery/<%= namespacing.underscore %>/admin/<%= plural_name %>',
            :action => 'index'
          }
          plugin.pathname = root

          plugin.activity = {
            :class_name => :'refinery/<%= namespacing.underscore %>/<%= singular_name %>'<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
            :title => '<%= title.name %>'<% end %>
          }
          <% unless namespacing.underscore == plural_name -%>plugin.menu_match = %r{refinery/<%= namespacing.underscore %>/<%= plural_name %>(/.*)?$}<% end %>
        end
      end

      class << self
        def load_seed
          Dir[File.expand_path('../../../../db/seeds/*.rb', __FILE__)].each do |seed_file|
            load(seed_file)
          end
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::<%= class_name.pluralize %>)
      end
    end
  end
end

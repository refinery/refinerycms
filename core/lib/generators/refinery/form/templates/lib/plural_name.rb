require 'refinery'

module Refinery
  module <%= class_name.pluralize %>
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
          plugin.menu_match = %r{(admin|refinery)/(<%= plural_name %>|<%= singular_name %>_settings)/?}
          plugin.activity = {
            :class => <%= class_name %><% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
            :title => '<%= title.name %>'
          <% end %>}
        end
      end
    end
  end
end

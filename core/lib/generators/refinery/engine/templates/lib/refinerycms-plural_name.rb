module Refinery
  autoload :<%= class_name.pluralize %>Generator, File.expand_path('../generators/refinery/<%= plural_name %>_generator', __FILE__)

  module <%= class_name.pluralize %><%= 'Engine' if plural_name == singular_name %>
    class Engine < Rails::Engine
      isolate_namespace Refinery
      engine_name :refinery_<%= plural_name %>

      config.after_initialize do
        Refinery.register_engine(Refinery::<%= class_name.pluralize %>)
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
          plugin.url = '/refinery/<%= plural_name %>'
          plugin.pathname = root
          plugin.activity = {
            :class_name => "Refinery::<%= class_name %>"<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
            :title => '<%= title.name %>'<% end %>
          }
        end
      end
    end

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end
  end
end

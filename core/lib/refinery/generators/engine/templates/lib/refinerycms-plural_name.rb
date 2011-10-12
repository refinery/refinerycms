require 'refinerycms-core'

module Refinery
  module <%= class_name.pluralize %><%= 'Engine' if plural_name == singular_name %>

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < Rails::Engine
      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
          plugin.url = '/refinery/<%= plural_name %>'
          plugin.pathname = root
          plugin.activity = {
            :class => ::Refinery::<%= class_name %><% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
            :title => '<%= title.name %>'<% end %>
          }
        end
      end
    end
  end
end

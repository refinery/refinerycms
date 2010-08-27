require 'refinery'

module Refinery
  module <%= class_name.pluralize %>
    class Engine < Rails::Engine
      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
          plugin.activity = {:class => <%= class_name %><% if attributes.first.name != "title" %>, :title => '<%= attributes.select { |a| a.type.to_s == "string" }.first.name %>'<% end %>}
        end
      end
    end
  end
end

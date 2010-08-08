module RefineryStaticAssetsEngine
  class Engine < Rails::Engine
    initializer "static assets" do |app|
      app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
    end
  end
end

Refinery::Plugin.register do |plugin|
  plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
  plugin.activity = {
    :class => <%= class_name %><% if attributes.first.name != "title" %>,
    :title => '<%= attributes.select { |a| a.type.to_s == "string" }.first.name %>'
  <% end %>}
end

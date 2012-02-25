if defined?(::Refinery::User)
  ::Refinery::User.all.each do |user|
    if user.plugins.where(:name => 'refinerycms-<%= namespacing.underscore %>').blank?
      user.plugins.create(:name => 'refinerycms-<%= namespacing.underscore %>',
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

<% unless skip_frontend? %>
url = "/<%= namespacing.underscore %>/<%= plural_name %>"
if defined?(::Refinery::Page) && ::Refinery::Page.where(:link_url => url).empty?
  page = ::Refinery::Page.create(
    :title => '<%= class_name.pluralize.underscore.titleize %>',
    :link_url => url,
    :deletable => false,
    :menu_match => "^#{url}(\/|\/.+?|)$"
  )
  Refinery::Pages.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end
<% end %>

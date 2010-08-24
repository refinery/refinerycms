User.find(:all).each do |user|
  user.plugins.create(:name => "<%= class_name.pluralize.underscore.downcase %>",
                      :position => (user.plugins.maximum(:position) || -1) +1)
end

page = Page.create(
  :title => "<%= class_name.pluralize.underscore.titleize %>",
  :link_url => "/<%= plural_name %>",
  :deletable => false,
  :position => ((Page.maximum(:position, :conditions => "parent_id IS NULL") || -1)+1),
  :menu_match => "^/<%= plural_name %>(\/|\/.+?|)$"
)
Page.default_parts.each do |default_page_part|
  page.parts.create(:title => default_page_part, :body => nil)
end

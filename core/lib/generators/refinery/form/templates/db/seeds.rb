if defined?(::Refinery::User)
  ::Refinery::User.all.each do |user|
    if user.plugins.find_by_name('<%= class_name.pluralize.underscore.downcase %>').nil?
      user.plugins.create(:name => "<%= class_name.pluralize.underscore.downcase %>",
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

if defined?(::Refinery::Page)
  page = ::Refinery::Page.create(
    :title => "<%= class_name.pluralize.underscore.titleize %>",
    :link_url => "/<%= plural_name %>/new",
    :deletable => false,
    :position => ((::Refinery::Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => "^/<%= plural_name %>(\/|\/.+?|)$"
  )
  thank_you_page = ::Refinery::Page.create(
    :title => "Thank You",
    :link_url => "/<%= plural_name %>/thank_you",
    :deletable => false,
    :parent => page,
    :show_in_menu => false,
    :position => page.children.count
  )
  ::Refinery::Page.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
    thank_you_page.parts.create(:title => default_page_part, :body => nil)
  end
end
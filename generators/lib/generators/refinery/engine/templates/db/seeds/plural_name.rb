if defined?(::Refinery::User)
  ::Refinery::User.all.each do |user|
    if user.plugins.where(:name => '<%= class_name.pluralize.underscore.downcase %>').blank?
      user.plugins.create(:name => '<%= class_name.pluralize.underscore.downcase %>',
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

if defined?(::Refinery::Page)
  page = ::Refinery::Page.create(
    :title => '<%= class_name.pluralize.underscore.titleize %>',
    :link_url => '/<%= plural_name %>',
    :deletable => false,
    :position => ((::Refinery::Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => '^/<%= plural_name %>(\/|\/.+?|)$'
  )
  ::Refinery::Page.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end

class Admin::<%= class_name.pluralize %>Controller < Admin::BaseController

  crudify :<%= singular_name %><% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
          :title_attribute => '<%= title.name %>'
<% end %>

end

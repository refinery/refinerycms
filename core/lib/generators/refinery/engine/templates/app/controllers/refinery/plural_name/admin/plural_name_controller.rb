module Refinery
  module <%= class_name.pluralize %>
    module Admin
      class <%= class_name.pluralize %>Controller < ::Refinery::AdminController

<<<<<<< HEAD
        crudify :'refinery/<%= plural_name %>/<%= singular_name %>'<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
=======
        crudify :'refinery/<%= singular_name %>'<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
>>>>>>> Restructured engine generator according to namespacing conventions. Made form_actions, activity and crud forward and backward compatible in this regard
                :title_attribute => '<%= title.name %>'<% end %><% if plural_name == singular_name %>,
                  :redirect_to_url => :refinery_<%= plural_name %>_admin_<%= singular_name %>_index_path
    <% end %>, :xhr_paging => true

      end
    end
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> Restructured engine generator according to namespacing conventions. Made form_actions, activity and crud forward and backward compatible in this regard

module Refinery
  module <%= class_name.pluralize %>
    module Admin
      class <%= class_name.pluralize %>Controller < ::Refinery::AdminController

        crudify :'refinery/<%= plural_name %>/<%= singular_name %>'<% if (title = attributes.detect { |a| a.type.to_s == "string" }).present? and title.name != 'title' %>,
                :title_attribute => '<%= title.name %>'<% end %><% if plural_name == singular_name %>,
                  :redirect_to_url => :refinery_<%= plural_name %>_admin_<%= singular_name %>_index_path
    <% end %>, :xhr_paging => true

      end
    end
  end
end

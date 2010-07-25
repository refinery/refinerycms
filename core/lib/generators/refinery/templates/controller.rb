class Admin::<%= class_name.pluralize %>Controller < Admin::BaseController

  crudify :<%= singular_name %>, :title_attribute => :<%= attributes.first.name %>

end

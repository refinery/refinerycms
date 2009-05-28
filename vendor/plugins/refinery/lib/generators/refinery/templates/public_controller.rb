class <%= class_name.pluralize %>Controller < ApplicationController

  def show
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
  end
  
end
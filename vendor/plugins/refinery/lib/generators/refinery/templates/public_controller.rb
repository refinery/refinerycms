class <%= class_name.pluralize %>Controller < ApplicationController

  before_filter :find_page

  def index
    @<%= plural_name %> = <%= class_name %>.find(:all, :order => "position ASC")
    present(find_page)
  end

  def show
    @<%= plural_name %> = <%= class_name %>.find(:all, :order => "position ASC") # for body_content_right
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    present(@<%= singular_name %>)
  end

protected

  def find_page
    Page.find_by_link_url("/<%= plural_name %>")
  end

  def present(model)
    presenter_name = "#{model.class}Presenter"
    presenter = begin
      Object.const_get(presenter_name)
    rescue NameError => e
      BasePresenter
    end
    @page = presenter.new(model)
  end

end

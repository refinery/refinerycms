class Admin::PagesDialogsController < Admin::DialogsController

  require 'net/http'

  crudify :page

  def link_to
    @pages = Page.paginate :page => params[:page],
                             :conditions => 'parent_id is null',
                             :order => 'position ASC',
                             :per_page => Page.per_page(dialog=true)

    @resources = Resource.paginate :page => params[:resource_page],
                                   :order => 'created_at DESC',
                                   :per_page => Resource.per_page(dialog=true)

    # web address link
    @web_address_text = "http://"
    @web_address_text = params[:current_link] if params[:current_link].present? and params[:current_link] =~ /^http:\/\//
    @web_address_target_blank = (params[:target_blank] == "true")

    # mailto link
    if params[:current_link].present?
      if params[:current_link] =~ /^mailto:/
        @email_address_text = params[:current_link].split("mailto:")[1].split('?')[0]
      end
      @email_default_subject_text = params[:current_link].split('?subject=')[1] || params[:subject]
      @email_default_body_text = params[:current_link].split('?body=')[1] || params[:body]
    end

    # resource link
    if params[:current_link].present?
      is_resource_link = params[:current_link].include?("/system/resources")
    end

    if params[:paginating].present?
      @page_area_selected = (params[:paginating] == "your_page")
      @resource_area_selected = (params[:paginating] == "resource_file")
    else
      @page_area_selected = (!is_resource_link and @web_address_text == "http://" and @email_address_text.blank?)
      @web_address_area_selected = (@web_address_text != "http://")
      @email_address_area_selected = @email_address_text.present?
      @resource_area_selected = is_resource_link
    end
  end

  def test_url
    unless params[:url].blank?
      url = URI.parse(params[:url])

      http = Net::HTTP.new(url.host)
      request = Net::HTTP::Get.new(url.path.blank? ? "/" : url.path)

      response = http.request request

      render :json => {:result => case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        'success'
      else
        'failure'
      end }
    end

    rescue
      render :json => {:result => 'failure'}
  end

  def test_email
    unless params[:email].blank?
      valid = params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

      render :json => if valid
        {:result => 'success'}
      else
        {:result => 'failure'}
      end
    end
  end

end

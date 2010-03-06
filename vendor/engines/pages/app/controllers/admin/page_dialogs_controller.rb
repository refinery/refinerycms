class Admin::PageDialogsController < Admin::DialogsController

  require 'net/http'

  crudify :page

  def link_to
    @pages = Page.paginate :page => params[:page],
                             :conditions => 'parent_id is null',
                             :order => 'position ASC',
                             :per_page => Page.per_page(dialog=true)

    @resources = Resource.paginate :page => params[:resource_page], :order => 'created_at DESC', :per_page => Resource.per_page(dialog=true)
  end

  def test_url
    unless params[:url].blank?
      url = URI.parse(params[:url])

      http = Net::HTTP.new(url.host)
      request = Net::HTTP::Get.new(url.path.blank? ? "/" : url.path)

      response = http.request request

      render :json => case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        {:result => 'success'}
      else
        {:result => 'failure'}
      end
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

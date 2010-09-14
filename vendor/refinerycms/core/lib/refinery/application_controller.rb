require 'action_controller'

module Refinery::ApplicationController

  def self.included(controller)
    controller.send :include, InstanceMethods
    controller.send :include, ClassMethods
  end

  module ClassMethods
    def self.included(c) # Extend controller
      c.helper_method :home_page?,
                      :local_request?,
                      :just_installed?,
                      :from_dialog?,
                      :admin?,
                      :login?

      c.protect_from_forgery # See ActionController::RequestForgeryProtection

      c.send :include, Crud # basic create, read, update and delete methods
      c.send :include, AuthenticatedSystem

      c.send :before_filter, :find_pages_for_menu,
                             :show_welcome_page?

      c.send :after_filter, :store_current_location!,
                            :if => Proc.new {|c| c.send(:refinery_user?) rescue false }

      c.send :rescue_from, ActiveRecord::RecordNotFound,
                           ActionController::UnknownAction,
                           ActionView::MissingTemplate,
                           :with => :error_404
    end
  end

  module InstanceMethods
    def admin?
      controller_name =~ %r{^admin/}
    end

    def error_404(exception=nil)
      if (@page = Page.where(:menu_match => "^/404$").includes(:parts, :slugs).first).present?
        # render the application's custom 404 page with layout and meta.
        render :template => "/pages/show",
               :format => 'html',
               :status => 404
      else
        # fallback to the default 404.html page.
        file = Rails.root.join('public', '404.html')
        file = Refinery.root.join('vendor', 'refinerycms', 'core', 'public', '404.html') unless file.exist?
        render :file => file.cleanpath.to_s,
               :layout => false,
               :status => 404
      end
    end

    def from_dialog?
      params[:dialog] == "true" or params[:modal] == "true"
    end

    def home_page?
      root_url(:only_path => true) == request.path
    end

    def just_installed?
      Role[:refinery].users.empty?
    end

    def local_request?
      Rails.env.development? or request.remote_ip =~ /(::1)|(127.0.0.1)|((192.168).*)/
    end

    def login?
      (controller_name =~ /^(user|session)(|s)/ and not admin?) or just_installed?
    end

  protected

    # get all the pages to be displayed in the site menu.
    def find_pages_for_menu
      @menu_pages = Page.where(:show_in_menu => true, :draft => false).order('lft ASC').includes(:parts)
    end

    # use a different model for the meta information.
    def present(model)
      presenter = (Object.const_get("#{model.class}Presenter") rescue ::Refinery::BasePresenter)
      @meta = presenter.new(model)
    end

    # this hooks into the Rails render method.
    def render(action = nil, options = {}, &blk)
      present(@page) unless admin? or @meta.present?
      super
    end

    def show_welcome_page?
      render :template => "/welcome", :layout => "login" if just_installed? and controller_name != "users"
    end

  private
    def store_current_location!
      if admin?
        # ensure that we don't redirect to AJAX or POST/PUT/DELETE urls
        session[:refinery_return_to] = request.path if request.get? and !request.xhr? and !from_dialog?
      elsif defined?(@page) and @page.present?
        session[:website_return_to] = @page.url
      end
    end
  end
end

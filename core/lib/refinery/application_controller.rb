require 'zilch/authorisation_manager'

module Refinery
  module ApplicationController

    def self.included(base) # Extend controller
      base.helper_method :home_page?,
                         :local_request?,
                         :from_dialog?,
                         :admin?,
                         :refinery_logout_path,
                         :current_refinery_user

      base.protect_from_forgery # See ActionController::RequestForgeryProtection

      base.send :include, Refinery::Crud # basic create, read, update and delete methods

      if Refinery::Core.rescue_not_found
        base.rescue_from ::ActiveRecord::RecordNotFound,
                         ::AbstractController::ActionNotFound,
                         ::ActionView::MissingTemplate,
                         :with => :error_404
      end
    end

    def admin?
      %r{\Aadmin/} === controller_name
    end

    def error_404(exception = nil)
      # fallback to the default 404.html page.
      file = Rails.root.join 'public', '404.html'
      file = Refinery.roots('refinery/core').join('public', '404.html') unless file.exist?
      render :file => file.cleanpath.to_s.gsub(%r{#{file.extname}$}, ''),
             :layout  => false, :status => 404, :formats => [:html]
      return false
    end

    def from_dialog?
      params[:dialog] == 'true' || params[:modal] == 'true'
    end

    def home_page?
      %r{^#{Regexp.escape(request.path)}} === refinery.root_path
    end

    def local_request?
      Rails.env.development? || /(::1)|(127.0.0.1)|((192.168).*)/ === request.remote_ip
    end

    def refinery_logout_path
      nil
    end

    def current_refinery_user
      Zilch::AuthorisationManager.instance.current_user
    end

    protected

    # use a different model for the meta information.
    def present(model)
      @meta = presenter_for(model).new(model)
    end

    def presenter_for(model, default = BasePresenter)
      return default if model.nil?

      "#{model.class.name}Presenter".constantize
    rescue NameError
      default
    end
  end
end

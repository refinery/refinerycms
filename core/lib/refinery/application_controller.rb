module Refinery
  module ApplicationController

    extend ActiveSupport::Concern

    included do # Extend controller
      helper_method :home_page?,
                    :local_request?,
                    :just_installed?,
                    :from_dialog?,
                    :admin?,
                    :login?

      protect_from_forgery # See ActionController::RequestForgeryProtection

      send :include, Refinery::Crud # basic create, read, update and delete methods

      if Refinery::Core.rescue_not_found
        send :rescue_from, ActiveRecord::RecordNotFound,
                           ::AbstractController::ActionNotFound,
                           ActionView::MissingTemplate,
                           :with => :error_404
      end
    end

    def admin?
      %r{^admin/} === controller_name
    end

    def error_404(exception=nil)
      # fallback to the default 404.html page.
      file = Rails.root.join 'public', '404.html'
      file = Refinery.roots(:'refinery/core').join('public', '404.html') unless file.exist?
      render :file => file.cleanpath.to_s.gsub(%r{#{file.extname}$}, ''),
             :layout => false, :status => 404, :formats => [:html]
      return false
    end

    def from_dialog?
      params[:dialog] == 'true' or params[:modal] == 'true'
    end

    def home_page?
      %r{^#{Regexp.escape(request.path)}} === refinery.root_path
    end

    def just_installed?
      Refinery::Role[:refinery].users.empty?
    end

    def local_request?
      Rails.env.development? || /(::1)|(127.0.0.1)|((192.168).*)/ === request.remote_ip
    end

    def login?
      (/^(user|session)(|s)/ === controller_name && !admin?) || just_installed?
    end

  protected

    # use a different model for the meta information.
    def present(model)
      @meta = presenter_for(model).new(model)
    end

    def presenter_for(model, default=BasePresenter)
      return default if model.nil?

      "#{model.class.name}Presenter".constantize
    rescue NameError
      default
    end
  end
end

require 'action_controller'
# require application helper so that we can include our helpers into it.
if defined?(Rails) and !Rails.root.nil?
  if (app_helper = Rails.root.join('app', 'helpers', 'application_helper.rb')).file?
    require app_helper.to_s
  end
end

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

      send :before_filter, :find_pages_for_menu,
                             :show_welcome_page?

      send :after_filter, :store_current_location!,
                            :if => Proc.new {|c| send(:refinery_user?) }

      if Refinery.rescue_not_found
        send :rescue_from, ActiveRecord::RecordNotFound,
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
        # fallback to the default 404.html page.
        file = Rails.root.join('public', '404.html')
        file = Refinery.roots(:'refinery/core').join('public', '404.html') unless file.exist?
        render :file => file.cleanpath.to_s,
               :layout => false,
               :status => 404
      end

      def from_dialog?
        params[:dialog] == 'true' or params[:modal] == 'true'
      end

      def home_page?
        main_app.root_path =~ /^#{Regexp.escape(request.path)}\/?/
      end

      def just_installed?
        ::Refinery::Role[:refinery].users.empty?
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
        raise NotImplementedError, 'Please implement protected method find_pages_for_menu'
      end

      # use a different model for the meta information.
      def present(model)
        presenter = (Object.const_get("#{model.class}Presenter") rescue ::Refinery::BasePresenter)
        @meta = presenter.new(model)
      end

      def show_welcome_page?
        if just_installed? and controller_name != 'users'
          render :template => 'refinery/welcome', :layout => 'login'
        end
      end

    private
      def store_current_location!
        if admin? and request.get? and !request.xhr? and !from_dialog?
          # ensure that we don't redirect to AJAX or POST/PUT/DELETE urls
          session[:refinery_return_to] = request.path
        end
      end
    end
  end
end

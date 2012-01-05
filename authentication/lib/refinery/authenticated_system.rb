module Refinery
  module AuthenticatedSystem
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.fullpath
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # This just defines the devise method for after sign in to support
    # engine namespace isolation...
    def after_sign_in_path_for(resource_or_scope)
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      home_path = "#{scope}_root_path"
      respond_to?(home_path, true) ? refinery.send(home_path) : refinery.admin_root_path
    end

    def after_sign_out_path_for(resource_or_scope)
      refinery.root_path
    end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      admin_refinery_user_path
    end

    def refinery_user?
      refinery_user_signed_in? && current_refinery_user.has_role?(:refinery)
    end

    protected :store_location, :redirect_back_or_default, :refinery_user?

    def self.included(base)
      base.send :helper_method, :current_refinery_user, :current_user_session,
        :refinery_user_signed_in?, :refinery_user? if base.respond_to? :helper_method
    end
  end
end

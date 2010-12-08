module AuthenticatedSystem
  protected
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

    def refinery_user?
      user_signed_in? && current_user.has_role?(:refinery)
    end

    def self.included(base)
      base.send :helper_method, :current_user, :current_user_session, :user_signed_in?, :refinery_user? if base.respond_to? :helper_method
    end

end

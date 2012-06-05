module Refinery
  module AuthenticatedSystem
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.fullpath.sub("//", "/")
    end

    # Clear and return the stored location
    def pop_stored_location
      session.delete(:return_to)
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(pop_stored_location || default)
    end

    # This defines the devise method for refinery routes
    def signed_in_root_path(resource_or_scope)
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      home_path = "#{scope}_root_path"
      if respond_to?(home_path, true)
        refinery.send(home_path)
      elsif respond_to?(:admin_root_path)
        refinery.admin_root_path
      else
        "/"
      end
    end

    # Pops the stored url, trims the sneaky "//" from it, and returns it.
    #
    # Making sure bad urls aren't stored in the first place should probably be
    # a part of the Devise::FailureApp
    def sanitized_stored_location_for(resource_or_scope)
      # `stored_location_for` is the devise method that pops the
      # scoped `return_to` key
      location = stored_location_for(resource_or_scope)
      location.sub!("//", "/") if location.respond_to?(:sub!)
      location
    end

    # This just defines the devise method for after sign in to support
    # extension namespace isolation...
    def after_sign_in_path_for(resource_or_scope)
      pop_stored_location ||
      sanitized_stored_location_for(resource_or_scope) ||
      signed_in_root_path(resource_or_scope)
    end

    def after_sign_out_path_for(resource_or_scope)
      refinery.root_path
    end

    def refinery_user?
      refinery_user_signed_in? && current_refinery_user.has_role?(:refinery)
    end

    protected :store_location, :pop_stored_location, :redirect_back_or_default,
              :sanitized_stored_location_for, :refinery_user?

    def self.included(base)
      if base.respond_to? :helper_method
        base.send :helper_method, :current_refinery_user, :current_user_session,
                                  :refinery_user_signed_in?, :refinery_user?
      end
    end
  end
end

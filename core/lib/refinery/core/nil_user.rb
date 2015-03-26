require 'zilch/authorisation/nil_user'
require 'refinery/plugins'

module Refinery
  module Core
    class NilUser < Zilch::Authorisation::NilUser
      # The default NilUser has all roles and can access all plugins.
      # Should be overridden in authentication solutions.
      def has_role?(role)
        true
      end

      # Returns all registered plugins.
      # Should be overridden in authentication solutions.
      def plugins
        Refinery::Plugins.registered
      end

      # Returns true.
      # Should be overridden in authentication solutions.
      # A real solution might be: `Refinery::Plugins.active.names.include?(name)`
      def has_plugin?(name)
        true
      end

      # Returns a URL to the first plugin with a URL in the menu. Used for
      # admin users' root admin url.
      # Should be overridden in authentication solutions.
      def landing_url
        plugins.first_url_in_menu
      end
    end
  end
end

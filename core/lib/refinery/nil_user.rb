require 'zilch/nil_user'
require 'refinery/plugins'

module Refinery
  module Core
    class NilUser < Zilch::NilUser

      # Returns all plugins in system. Override in authentication solutions.
      def plugins
        Refinery::Plugins.registered
      end


      def landing_url
        plugins.first_url_in_menu
      end
    end
  end
end

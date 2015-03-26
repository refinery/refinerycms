require "zilch/authorisation/authorisation_manager"
require "refinery/core/authorisation_adapter"

module Refinery
  module Core
    class AuthorisationManager < Zilch::Authorisation::AuthorisationManager

      def default_adapter
        @default_adapter ||= Refinery::Core::AuthorisationAdapter.new
      end

    end
  end
end

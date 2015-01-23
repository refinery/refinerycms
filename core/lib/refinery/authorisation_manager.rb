require 'zilch/authorisation/authorisation_manager'
require 'refinery/nil_user'

module Refinery
  module Core
    class AuthorisationManager < Zilch::Authorisation::AuthorisationManager
      private def user_factory
        Refinery::Core::NilUser.method(:new)
      end
    end
  end
end

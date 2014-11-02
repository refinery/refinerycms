require 'zilch/authorisation_manager'
require 'refinery/nil_user'

module Refinery
  module Core
    class AuthorisationManager < Zilch::AuthorisationManager
      private def user_factory
        Refinery::Core::NilUser.method(:new)
      end
    end
  end
end

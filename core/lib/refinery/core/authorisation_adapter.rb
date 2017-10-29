require 'refinery/core/nil_user'

module Refinery
  module Core
    class AuthorisationAdapter < Zilch::Authorisation::Adapters::Default

      def current_user
        @current_user ||= Refinery::Core::NilUser.new
      end

    end
  end
end

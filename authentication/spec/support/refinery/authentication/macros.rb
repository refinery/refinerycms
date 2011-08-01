module Refinery
  module Authentication
    module Macros
      def login_user
        @user = Factory(:user)
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in @user
      end

      def login_refinery_user
        @refinery_user = Factory(:refinery_user)
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in @refinery_user
      end

      def login_refinery_translator
        @refinery_translator = Factory(:refinery_translator)
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in @refinery_translator
      end
    end
  end
end

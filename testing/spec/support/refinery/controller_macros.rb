module Refinery
  module ControllerMacros
    def login_user
      before (:each) do
        @user = Factory(:user)
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in @user
      end
    end

    def login_refinery_user
      before (:each) do
        @refinery_user = Factory(:refinery_user)
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in @refinery_user
      end
    end

    def login_refinery_translator
      before (:each) do
        @refinery_translator = Factory(:refinery_translator)
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in @refinery_translator
      end
    end
  end
end

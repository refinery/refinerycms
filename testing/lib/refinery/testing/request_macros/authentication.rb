require 'refinery/testing/factories/user'

module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def login_refinery_user
          before(:each) do
            FactoryGirl.create(:refinery_user, :username => "refinerycms",
                                    :password => "123456",
                                    :password_confirmation => "123456",
                                    :email => "refinerycms@refinerycms.com")
            visit new_refinery_user_session_path
            fill_in "Login", :with => "refinerycms"
            fill_in "Password", :with => "123456"
            click_button "Sign in"
          end
        end
      end
    end
  end
end

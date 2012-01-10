module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def login_refinery_user
          before do
            FactoryGirl.create(:refinery_user, :username => "refinerycms",
                                    :password => "123456",
                                    :password_confirmation => "123456",
                                    :email => "refinerycms@refinerycms.com")
            visit refinery.new_refinery_user_session_path
            fill_in "Login", :with => "refinerycms"
            fill_in "Password", :with => "123456"
            click_button "Sign in"
          end
        end

        def login_refinery_translator
          before do
            FactoryGirl.create(:refinery_user)
            user = FactoryGirl.create(:refinery_translator, :password => "123456",
                                      :password_confirmation => "123456")

            visit refinery.new_refinery_user_session_path
            fill_in "Login", :with => user.username
            fill_in "Password", :with => "123456"
            click_button "Sign in"
          end
        end
      end
    end
  end
end

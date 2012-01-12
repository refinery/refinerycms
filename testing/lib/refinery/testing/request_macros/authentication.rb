module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def login_refinery_user
          before(:each) do
            password = '123456'
            refinery_user = FactoryGirl.create(:refinery_user, {
              :username => "refinerycms",
              :password => password,
              :password_confirmation => password,
              :email => "refinerycms@refinerycms.com"
            })

            visit new_refinery_user_session_path

            fill_in "Login", :with => refinery_user.username
            fill_in "Password", :with => password

            click_button "Sign in"
          end
        end

        def login_refinery_translator
          before(:each) do
            password = '123456'
            FactoryGirl.create(:refinery_user)
            user = FactoryGirl.create(:refinery_translator, {
              :password => password,
              :password_confirmation => password
            })

            visit new_refinery_user_session_path

            fill_in "Login", :with => user.username
            fill_in "Password", :with => password

            click_button "Sign in"
          end
        end
      end
    end
  end
end

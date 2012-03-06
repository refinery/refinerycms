module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def login_with(factory)
          let!(:logged_in_user) { Factory.create(factory) }

          before do
            visit refinery.new_refinery_user_session_path

            fill_in "Login", :with => logged_in_user.username
            fill_in "Password", :with => logged_in_user.password

            click_on "Sign in"
          end
        end

        def login_refinery_user
          login_with(:refinery_user)
        end

        def login_refinery_superuser
          login_with(:refinery_superuser)
        end

        def login_refinery_translator
          login_with(:refinery_translator)
        end
      end
    end
  end
end

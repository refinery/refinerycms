module NavigationHelpers
  module Refinery
    module Authentication
      def path_to(page_name)
        case page_name

        when /the list of users/
          admin_users_path

        when /the login page/
          new_user_session_path

        when /the forgot password page/
          new_user_password_path

        when /the reset password page/
          edit_user_password_path(:reset_password_token => @user.reset_password_token)
        else
          nil
        end
      end
    end
  end
end

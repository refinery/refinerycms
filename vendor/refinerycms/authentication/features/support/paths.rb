module NavigationHelpers
  module Refinery
    module Authentication
      def path_to(page_name)
        case page_name

        when /the list of users/
          admin_users_path

        when /the login page/
          new_session_path

        when /the forgot password page/
          forgot_users_path

        when /the reset password page/
          reset_users_path(:reset_code => @user.perishable_token)
        else
          nil
        end
      end
    end
  end
end

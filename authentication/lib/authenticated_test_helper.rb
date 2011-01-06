module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    @request.session[:user_id] = (users(user).id if user)
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = (ActionController::HttpAuthentication::Basic.encode_credentials(users(user).username, 'test') if user)
  end
end

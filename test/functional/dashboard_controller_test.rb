require File.dirname(__FILE__) + '/../test_helper'
require 'admin/dashboard_controller'

class Admin::DashboardController; def rescue_action(e) raise e end; end

class DashboardControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    @controller = Admin::DashboardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    login_as(:quentin)

    get :index
    assert_response :success
    assert_not_nil assigns(:recent_activity)
  end

end

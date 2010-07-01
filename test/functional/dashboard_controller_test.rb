require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'admin/dashboard_controller'

class Admin::DashboardController; def rescue_action(e) raise e end; end

class DashboardControllerTest < ActionController::TestCase

  fixtures :users, :pages

  def setup
    @controller = Admin::DashboardController.new
    users(:quentin).add_role(:refinery)
    login_as(:quentin)
  end

  def test_should_get_index
    get :index
    assert_response :success

    assert_not_nil assigns(:recent_activity)
  end

  def test_recent_activity_should_report_activity
    sleep 1
    pages(:home_page).update_attribute(:updated_at, Time.now)

    get :index

    # now the home page is updated is it at the top?
    assert_equal pages(:home_page).id, assigns(:recent_activity).first.id
  end

  def test_should_require_login_and_redirect
    logout

    get :index
    assert_response :redirect
    assert_nil assigns(:recent_activity)
  end

end

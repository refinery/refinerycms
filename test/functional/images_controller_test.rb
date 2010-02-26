require File.dirname(__FILE__) + '/../test_helper'
require 'admin/images_controller'

class Admin::ImagesController; def rescue_action(e) raise e end; end

class ImagesControllerTest < ActionController::TestCase
  
  fixtures :users, :images
  
  def setup
    @controller = Admin::ImagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_get_index
    login_as(:quentin)

    get :index
    assert_response :success
    assert_not_nil assigns(:images)
    assert assigns(:images).size, Image.count
  end
  
  def test_should_require_login_and_redirect

    get :index
    assert_response :redirect
    assert_nil assigns(:images)
  end
  
  # we need to somehow make it so that recent activity comes
  # into tests so we can check the order.
  # not sure why the recent activity assign has no activity
  
end
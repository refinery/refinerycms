require File.dirname(__FILE__) + '/../test_helper'
require 'admin/images_controller'

class Admin::ImagesController; def rescue_action(e) raise e end; end

class ImagesControllerTest < ActionController::TestCase
  
  fixtures :users, :images
  
  def setup
    @controller = Admin::ImagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    login_as(:quentin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:images)
    assert assigns(:images).size, Image.count
  end

  def test_new_image_form
    get :new
    assert_not_nil assigns(:image)
    assert_not_nil assigns(:url_override)
  end
  
  def test_search
    get :index, :search => "Car"
    
    assert 1, assigns(:images).size
    assert images(:the_world), assigns(:images).first
    assert_not_nil assigns(:images)
  end
  
  def test_should_require_login_and_redirect
    logout
    
    get :index
    assert_response :redirect
    assert_nil assigns(:images)
  end
  
  def test_edit
    get :edit, :id => images(:the_world).id
    
    assert_response :success
    
    assert_not_nil assigns(:image)
    assert_equal images(:the_world), assigns(:image)
  end
  
  def test_insert
    
  end
  
  def test_create
    
  end
  
  def test_destroy
    
  end

end
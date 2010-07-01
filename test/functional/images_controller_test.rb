require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'admin/images_controller'

class Admin::ImagesController; def rescue_action(e) raise e end; end

class ImagesControllerTest < ActionController::TestCase

  fixtures :users, :images

  def setup
    @controller = Admin::ImagesController.new
    users(:quentin).add_role(:refinery)
    login_as(:quentin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:images)
    assert_equal assigns(:images).size, Image.count
  end

  def test_new_image_form
    get :new
    assert_not_nil assigns(:image)
    assert_not_nil assigns(:url_override)
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
    get :insert

    assert_not_nil assigns(:image)
    assert_not_nil assigns(:url_override)
  end

  def test_update
    put :update, :id => images(:the_world).id, :image => {}
    assert_redirected_to admin_images_path
  end

  def test_create_with_errors
    post :create # didn't provide an image to upload
    assert_not_nil assigns(:image)
    assert_response :success
  end

  def test_successful_create
    # This needs to be sorted out yet. I'm not sure how to upload
    # a file through tests

    # assert_difference('Image.count', +1) do
    #   post :create, :post => {} # didn't provide an image to upload
    #   assert_not_nil assigns(:image)
    #   assert_redirected_to admin_images_path
    # end
  end

  def test_destroy
    assert_difference('Image.count', -1) do
      delete :destroy, :id => images(:the_world).id
    end

    assert_redirected_to admin_images_path
  end

end

require 'test_helper'

class PlanesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:planes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_plane
    assert_difference('Plane.count') do
      post :create, :plane => { }
    end

    assert_redirected_to plane_path(assigns(:plane))
  end

  def test_should_show_plane
    get :show, :id => planes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => planes(:one).id
    assert_response :success
  end

  def test_should_update_plane
    put :update, :id => planes(:one).id, :plane => { }
    assert_redirected_to plane_path(assigns(:plane))
  end

  def test_should_destroy_plane
    assert_difference('Plane.count', -1) do
      delete :destroy, :id => planes(:one).id
    end

    assert_redirected_to planes_path
  end
end

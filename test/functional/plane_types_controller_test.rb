require 'test_helper'

class PlaneTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:plane_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_plane_type
    assert_difference('PlaneType.count') do
      post :create, :plane_type => { }
    end

    assert_redirected_to plane_type_path(assigns(:plane_type))
  end

  def test_should_show_plane_type
    get :show, :id => plane_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => plane_types(:one).id
    assert_response :success
  end

  def test_should_update_plane_type
    put :update, :id => plane_types(:one).id, :plane_type => { }
    assert_redirected_to plane_type_path(assigns(:plane_type))
  end

  def test_should_destroy_plane_type
    assert_difference('PlaneType.count', -1) do
      delete :destroy, :id => plane_types(:one).id
    end

    assert_redirected_to plane_types_path
  end
end

require File.dirname(__FILE__) + '/../test_helper'

# make sure the secret for request forgery protection is set (views will
# explicitly use the form_authenticity_token method which will fail otherwise)
AaasController.request_forgery_protection_options[:secret] = 'test_secret'

class AaasControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    get :index, :format => 'ext_json'
    assert_response :success
    assert_not_nil assigns(:aaas)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_aaa
    assert_difference('Aaa.count') do
      xhr :post, :create, :format => 'ext_json', :aaa => { }
    end

    assert_not_nil flash[:notice]
    assert_response :success
  end

  def test_should_show_aaa
    get :show, :id => aaas(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => aaas(:one).id
    assert_response :success
  end

  def test_should_update_aaa
    xhr :put, :update, :format => 'ext_json', :id => aaas(:one).id, :aaa => { }
    assert_not_nil flash[:notice]
    assert_response :success
  end

  def test_should_destroy_aaa
    assert_difference('Aaa.count', -1) do
      xhr :delete, :destroy, :id => aaas(:one).id
    end

    assert_response :success
  end
end

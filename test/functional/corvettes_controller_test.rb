require 'test_helper'

class CorvettesControllerTest < ActionController::TestCase
  setup do
    @corvette = corvettes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:corvettes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create corvette" do
    assert_difference('Corvette.count') do
      post :create, :corvette => @corvette.attributes
    end

    assert_redirected_to corvette_path(assigns(:corvette))
  end

  test "should show corvette" do
    get :show, :id => @corvette.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @corvette.to_param
    assert_response :success
  end

  test "should update corvette" do
    put :update, :id => @corvette.to_param, :corvette => @corvette.attributes
    assert_redirected_to corvette_path(assigns(:corvette))
  end

  test "should destroy corvette" do
    assert_difference('Corvette.count', -1) do
      delete :destroy, :id => @corvette.to_param
    end

    assert_redirected_to corvettes_path
  end
end

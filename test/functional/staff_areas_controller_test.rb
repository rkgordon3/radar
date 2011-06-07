require 'test_helper'

class StaffAreasControllerTest < ActionController::TestCase
  setup do
    @staff_area = staff_areas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staff_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staff_area" do
    assert_difference('StaffArea.count') do
      post :create, :staff_area => @staff_area.attributes
    end

    assert_redirected_to staff_area_path(assigns(:staff_area))
  end

  test "should show staff_area" do
    get :show, :id => @staff_area.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @staff_area.to_param
    assert_response :success
  end

  test "should update staff_area" do
    put :update, :id => @staff_area.to_param, :staff_area => @staff_area.attributes
    assert_redirected_to staff_area_path(assigns(:staff_area))
  end

  test "should destroy staff_area" do
    assert_difference('StaffArea.count', -1) do
      delete :destroy, :id => @staff_area.to_param
    end

    assert_redirected_to staff_areas_path
  end
end

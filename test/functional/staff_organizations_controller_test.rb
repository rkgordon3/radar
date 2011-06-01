require 'test_helper'

class StaffOrganizationsControllerTest < ActionController::TestCase
  setup do
    @staff_organization = staff_organizations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staff_organizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staff_organization" do
    assert_difference('StaffOrganization.count') do
      post :create, :staff_organization => @staff_organization.attributes
    end

    assert_redirected_to staff_organization_path(assigns(:staff_organization))
  end

  test "should show staff_organization" do
    get :show, :id => @staff_organization.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @staff_organization.to_param
    assert_response :success
  end

  test "should update staff_organization" do
    put :update, :id => @staff_organization.to_param, :staff_organization => @staff_organization.attributes
    assert_redirected_to staff_organization_path(assigns(:staff_organization))
  end

  test "should destroy staff_organization" do
    assert_difference('StaffOrganization.count', -1) do
      delete :destroy, :id => @staff_organization.to_param
    end

    assert_redirected_to staff_organizations_path
  end
end

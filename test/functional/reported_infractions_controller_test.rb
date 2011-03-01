require 'test_helper'

class ReportedInfractionsControllerTest < ActionController::TestCase
  setup do
    @reported_infraction = reported_infractions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reported_infractions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reported_infraction" do
    assert_difference('ReportedInfraction.count') do
      post :create, :reported_infraction => @reported_infraction.attributes
    end

    assert_redirected_to reported_infraction_path(assigns(:reported_infraction))
  end

  test "should show reported_infraction" do
    get :show, :id => @reported_infraction.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reported_infraction.to_param
    assert_response :success
  end

  test "should update reported_infraction" do
    put :update, :id => @reported_infraction.to_param, :reported_infraction => @reported_infraction.attributes
    assert_redirected_to reported_infraction_path(assigns(:reported_infraction))
  end

  test "should destroy reported_infraction" do
    assert_difference('ReportedInfraction.count', -1) do
      delete :destroy, :id => @reported_infraction.to_param
    end

    assert_redirected_to reported_infractions_path
  end
end

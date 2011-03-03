require 'test_helper'

class ReportLocationsControllerTest < ActionController::TestCase
  setup do
    @report_location = report_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_location" do
    assert_difference('ReportLocation.count') do
      post :create, :report_location => @report_location.attributes
    end

    assert_redirected_to report_location_path(assigns(:report_location))
  end

  test "should show report_location" do
    get :show, :id => @report_location.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @report_location.to_param
    assert_response :success
  end

  test "should update report_location" do
    put :update, :id => @report_location.to_param, :report_location => @report_location.attributes
    assert_redirected_to report_location_path(assigns(:report_location))
  end

  test "should destroy report_location" do
    assert_difference('ReportLocation.count', -1) do
      delete :destroy, :id => @report_location.to_param
    end

    assert_redirected_to report_locations_path
  end
end

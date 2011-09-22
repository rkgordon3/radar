require 'test_helper'

class TutorReportsControllerTest < ActionController::TestCase
  setup do
    @tutor_report = tutor_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tutor_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tutor_report" do
    assert_difference('TutorReport.count') do
      post :create, :tutor_report => @tutor_report.attributes
    end

    assert_redirected_to tutor_report_path(assigns(:tutor_report))
  end

  test "should show tutor_report" do
    get :show, :id => @tutor_report.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tutor_report.to_param
    assert_response :success
  end

  test "should update tutor_report" do
    put :update, :id => @tutor_report.to_param, :tutor_report => @tutor_report.attributes
    assert_redirected_to tutor_report_path(assigns(:tutor_report))
  end

  test "should destroy tutor_report" do
    assert_difference('TutorReport.count', -1) do
      delete :destroy, :id => @tutor_report.to_param
    end

    assert_redirected_to tutor_reports_path
  end
end

require 'test_helper'

class InterestedPartyReportsControllerTest < ActionController::TestCase
  setup do
    @interested_party_report = interested_party_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interested_party_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interested_party_report" do
    assert_difference('InterestedPartyReport.count') do
      post :create, :interested_party_report => @interested_party_report.attributes
    end

    assert_redirected_to interested_party_report_path(assigns(:interested_party_report))
  end

  test "should show interested_party_report" do
    get :show, :id => @interested_party_report.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @interested_party_report.to_param
    assert_response :success
  end

  test "should update interested_party_report" do
    put :update, :id => @interested_party_report.to_param, :interested_party_report => @interested_party_report.attributes
    assert_redirected_to interested_party_report_path(assigns(:interested_party_report))
  end

  test "should destroy interested_party_report" do
    assert_difference('InterestedPartyReport.count', -1) do
      delete :destroy, :id => @interested_party_report.to_param
    end

    assert_redirected_to interested_party_reports_path
  end
end

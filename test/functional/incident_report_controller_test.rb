require 'test_helper'

class IncidentReportControllerTest < ActionController::TestCase
  test "should get incident_report" do
    get :incident_report
    assert_response :success
  end

end

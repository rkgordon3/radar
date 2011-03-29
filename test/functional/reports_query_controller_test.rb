require 'test_helper'

class ReportsQueryControllerTest < ActionController::TestCase
  test "should get reports_query" do
    get :reports_query
    assert_response :success
  end

end

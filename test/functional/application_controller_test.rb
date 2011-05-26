require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  test "is_iphone_request?" do
    get :is_iphone_request?
    assert_response :success
  end

end

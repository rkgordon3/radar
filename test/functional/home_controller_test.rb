require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get landingpage" do
    get :landingpage
    assert_response :success
  end

end

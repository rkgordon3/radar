require 'test_helper'

class InterestedPartiesControllerTest < ActionController::TestCase
  setup do
    @interested_party = interested_parties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interested_parties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interested_party" do
    assert_difference('InterestedParty.count') do
      post :create, :interested_party => @interested_party.attributes
    end

    assert_redirected_to interested_party_path(assigns(:interested_party))
  end

  test "should show interested_party" do
    get :show, :id => @interested_party.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @interested_party.to_param
    assert_response :success
  end

  test "should update interested_party" do
    put :update, :id => @interested_party.to_param, :interested_party => @interested_party.attributes
    assert_redirected_to interested_party_path(assigns(:interested_party))
  end

  test "should destroy interested_party" do
    assert_difference('InterestedParty.count', -1) do
      delete :destroy, :id => @interested_party.to_param
    end

    assert_redirected_to interested_parties_path
  end
end

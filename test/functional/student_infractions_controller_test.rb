require 'test_helper'

class StudentInfractionsControllerTest < ActionController::TestCase
  setup do
    @student_infraction = student_infractions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_infractions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_infraction" do
    assert_difference('StudentInfraction.count') do
      post :create, :student_infraction => @student_infraction.attributes
    end

    assert_redirected_to student_infraction_path(assigns(:student_infraction))
  end

  test "should show student_infraction" do
    get :show, :id => @student_infraction.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @student_infraction.to_param
    assert_response :success
  end

  test "should update student_infraction" do
    put :update, :id => @student_infraction.to_param, :student_infraction => @student_infraction.attributes
    assert_redirected_to student_infraction_path(assigns(:student_infraction))
  end

  test "should destroy student_infraction" do
    assert_difference('StudentInfraction.count', -1) do
      delete :destroy, :id => @student_infraction.to_param
    end

    assert_redirected_to student_infractions_path
  end
end

require 'test_helper'

class StaffTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "new function" do
    staff = Staff.new
	assert_not_equal(staff, nil, "Failed to create new staff.")
  end
  test "set first name" do
	staff = Staff.new
	staff.email = "bdolan@smumn.edu"
    assert_not_equal(staff.email, nil, "Failed to set email.")	
  end
end

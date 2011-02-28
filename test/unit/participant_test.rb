require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  
  test "new function" do
    part = Participant.new
	assert_not_equal(part, nil, "Failed to create new participant.")
  end
  test "set first name" do
	part = Participant.new
	part.first_name = "John"
    assert_not_equal(part.first_name, nil, "Failed to set first name.")	
  end
  test "save" do
	part = Participant.new
	part.first_name = "John"
	assert part.save, "Failed to save participant."
  end

end

#cmd command --> ruby -I test test/unit/participant_test.rb
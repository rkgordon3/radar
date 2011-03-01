require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "has first name" do
    assert_not_equal(participants(:chris).first_name, nil, "Chris needs a name.")
  end
end

#cmd command --> ruby -I test test/unit/participant_test.rb
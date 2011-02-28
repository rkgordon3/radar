require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "new function" do
    report = Report.new
	assert_not_equal(report, nil, "Failed to create new report.")
  end
  test "set first name" do
	report = Report.new
	report.type = "FYI"
    assert_not_equal(report.type, nil, "Failed to set report type.")	
  end
  test "save" do
	report = Report.new
	report.type = "FYI"
	assert report.save, "Failed to save report."
  end
end

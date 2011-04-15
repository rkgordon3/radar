Given /^I am a logged in user of RADAR$/ do
  visit "/staffs/sign_in"
  fill_in "Email", :with => "radar.system.admin@smumn.edu"
  fill_in "Password", :with => "password"
  click_button "Sign in"
end

When /^I sumbit an incident report$/ do
  visit "/incident_reports/new_report"
  fill_in "report_annotation", :with => "testing from cucumber"
  select "Skemp Hall", :from => "report_building_id"
  fill_in "report_room_number", :with => "101"
  fill_in "report_approach_time", :with => "2011-04-15 13:52:55 -0500"
  click_button "Submit Report"
end

Then /^I should see the incident report in the database$/ do   
   page.should have_content("Report was successfully created.")
#  ir = IncidentReport.where(:approach_time => "2011-04-15 13:52:55 -0500")
#  puts "ir count = " + ir.count.to_s
#  ir.first.approach_time.should == "2011-04-15 13:52:55 -0500"
#  anno = Annotation.where(:text => "testing from cucumber")
#  anno.first.text.should == "testing from cucumber"
#  ir.destroy
end
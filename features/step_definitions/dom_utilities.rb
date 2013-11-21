include ApplicationHelper

When(/^the user visits the "(.*?)" page$/) do |text|
  visit send(named_route_from_text(text))
end

When(/^the user selects the "(.*?)" link$/) do |link|
  click_on(link)
end

When(/^the user fills in the "(.*?)" field with "(.*?)"$/) do |field, value|
    fill_in field, :with => value
end

When(/^the user selects "(.*?)" from the "(.*?)" menu$/) do |value, field|
	if field.eql?("buildings")
    select value, :from => field
  else
     field = field.downcase << "_id"
     select value, :from => field
  end
end

When(/^the user selects the "(.*?)" button$/) do |button|
  	click_button button
end

When(/^the user selects the "(.*?)" icon$/) do |icon|
  	click_button icon
  	#visit root_path
end

Then(/^the user selects the "(.*?)" checkbox$/) do |checkbox|
  check checkbox
end

Then(/^the (.*?) is selected$/) do |checkbox|
  check_save = checkbox.split(" ").each {|x| x.capitalize}.join
  id = Organization.find_by_type(check_save).id
  check check_save.downcase+"_#{id}"
end

Then(/^an edit link (should|should not) be available for (.*?)$/) do |polarity, user|
  staff = Staff.find_by_email(user)
  polarity = polarity.split.join("_")
  page.send(polarity,  have_xpath("//a[@href='/staffs/#{staff.id}/edit']"))
end

When(/^the user selects the (.*?) link on (.*?) (.*?)$/) do |link, model, name|
    within("div##{model}_#{model_id(model,name)}_div") do
      find_link(link).click
    end
end

Given /^I expect to click "([^"]*)" on a confirmation box saying "([^"]*)"$/ do |option, message|
	retval = (option == "OK") ? "true" : "false"
	evaluate_script("window.confirm = function (msg) {
		$.cookie('confirm_message', msg);
		return #{retval};
	}")
	 
	@expected_message = message
end

Then /^the confirmation box should have been displayed$/ do
	page.evaluate_script("$.cookie('confirm_message')").should_not be_nil
	page.evaluate_script("$.cookie('confirm_message')").should eq(@expected_message)
	page.evaluate_script("$.cookie('confirm_message', null)")
end
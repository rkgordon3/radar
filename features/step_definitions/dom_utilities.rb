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
	puts "================before click", page.html
  	click_button icon
  	#visit root_path
  	puts "----------------after click", page.html
end

Then(/^the user selects the "(.*?)" checkbox$/) do |checkbox|
  check checkbox
end

Then(/^the (.*?) is selected$/) do |checkbox|
  check_save = checkbox.split(" ").each {|x| x.capitalize}.join
  id = Organization.find_by_type(check_save).id
  check check_save.downcase+"_#{id}"
end

Then(/^an edit link (.*?) be available for (.*?)$/) do |type, user|
  staff = Staff.find_by_email(user)
  if type == "should"
    page.should have_xpath("//a[@href='/staffs/#{staff.id}/edit']")
  else
    page.should_not have_xpath("//a[@href='/staffs/#{staff.id}/edit']")
  end
end

When(/^the user selects the (.*?) link on (.*?) (.*?)$/) do |link, model, name|
    within("div##{model}_#{model.capitalize.constantize.find_by_name(name).id}_div") do
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
include ApplicationHelper

When(/^the user visits the "(.*?)" page$/) do |text|
  visit send(named_route_from_text(text))
end

When(/^the user visits the New (.*?) page$/) do |report_type|
  report_type = report_type.split.join("_").downcase
  visit("/#{report_type.pluralize}/new")
end

When(/^the user visits the "(.*?)" report page$/) do |report_type|
	report_type = report_type.delete(" ")
  visit("/reports?report_type=#{report_type}")
end

When(/^the user selects the "(.*?)" link$/) do |link|
  click_on(link)
end

When(/^the user fills in the "(.*?)" field with "(.*?)"$/) do |field, value|
  field = field.split.join("_").downcase
  fill_in field, :with => value rescue field = "report_" << field
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

And(/^the user selects the (.*?) checkbox for (.*?)$/) do |checkbox, model|
  check_save = checkbox.split.join("_")
  id = ["#{model}", "#{check_save}"].join("_")
  check "#{id}".downcase
end

Then(/^an edit link (should|should not) be available for (.*?) with (name|email) (.*?)$/) do 
  |polarity, model, name_or_email, identifier|
  puts "=========#{model}======="
  model_plural = model.delete(" ").tableize
  model = model.split(" ").each {|x| x.capitalize}.join
  id = model_id(model, identifier)
  polarity = polarity.split.join("_")
  page.send(polarity,  have_xpath("//a[@href='/#{model_plural}/#{id}/edit']"))
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
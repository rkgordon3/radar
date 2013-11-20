include ApplicationHelper

When(/^the user visits the "(.*?)" page$/) do |text|
  visit send(named_route_from_text(text))
end

When(/^the user selects the "(.*?)" link$/) do |link|
  click_link link
end

When(/^the user selects the "(.*?)" js link$/) do |link|
	click_link link
end

When(/^the user fills in the "(.*?)" field with "(.*?)"$/) do |field, value|
    fill_in field, :with => value
end

When(/^the user selects "(.*?)" from the "(.*?)" menu$/) do |value, field|
	field = field.downcase << "_id"
	select value, :from => field
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
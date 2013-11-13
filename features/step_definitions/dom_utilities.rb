include ApplicationHelper

When(/^the user visits the "(.*?)" page$/) do |text|
  visit send(named_route_from_text(text))
end
When(/^the user selects the "(.*?)" link$/) do |text|
  pending
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

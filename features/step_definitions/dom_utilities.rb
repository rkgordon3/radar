When(/^the user selects the "(.*?)" link$/) do |link|
   click_link link
end

When(/^the user fills in the "(.*?)" field with "(.*?)"$/) do |field, value|
  	fill_in field, :with => value
end

When(/^the user selects "(.*?)" from the "(.*?)" menu$/) do |value, field|
  	select value, :from => 'field'
end

When(/^the user selects the "(.*?)" button$/) do |button|
  	click_button button
end

When(/^the user selects the "(.*?)" icon$/) do |icon|
	puts "------------------ouput for icon selection------------------", page.html
  	click_button icon
  	visit root_path
  	#sleep(50)
  	puts "=================after icon click=================", page.html
end
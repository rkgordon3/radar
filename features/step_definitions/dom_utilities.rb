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
  	pending # express the regexp above with the code you wish you had
end
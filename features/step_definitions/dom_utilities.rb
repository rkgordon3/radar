include ApplicationHelper
When(/^the user selects the "(.*?)" link$/) do |text|
	puts "--------------before link click-----------", page.html
	link = page.find(:xpath, "//a[@id=#{link_id_from_text(text)}]")
   link.click 
   puts "-----------after link click----------", page.html
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

When /^the user visits the landing page$/ do
  visit('/staffs/sign_in')
end

And(/^"(.*?)" signs in with "(.*?)"$/) do |user, password|
  fill_in('staff[email]', :with => user)
  fill_in('staff[password]', :with => password)
  click_button('Sign in')
end

Then(/^the welcome message Hi, "(.*?)" should be displayed$/) do |text|
  page.should have_content(text)
end

And(/^the page should display "(.*?)" menu options containing a "(.*?) link$/) do |menu_option, sub_menu|
  xpath_value = generate_menu_item(menu_option, sub_menu)
  page.find(:xpath, "#{xpath_value}")
  #page.find(:xpath, "//div[@class='menu']/ul/li/a[@class='menubar_link' and @href='/staffs']")
  #page.find(:xpath, "//div[@class='menu']/ul/li/ul/li/a[@href='/staffs']")
  #page.find(:xpath, "//ul/li/a[@href='/buildings']")
  #page.find(:xpath, "//ul/li/a[@href='/areas']")
  #page.find(:xpath, "//ul/li/a[@href='/tasks']")
  #page.find(:xpath, "//ul/li/a[@href='/relationship_to_reports']")
end


   #| radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Manage     | a[@class='menubar_link' and @href='/staffs']|
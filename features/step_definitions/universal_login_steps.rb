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
  #print page.html
end

And(/^the page should display "(.*?)" menu options containing a "(.*?) link$/) do |menu_option, sub_menu|
  menu_option = menu_option.downcase
  sub_menu = sub_menu.chomp('"').downcase
  if menu_option.eql?(sub_menu)
    page.find(:xpath, "#{top_level_value(menu_option)}")
  elsif menu_option == "search"
    page.find(:xpath, "#{search_value(menu_option, sub_menu)}")
  elsif menu_option == "manage"
    page.find(:xpath, "#{manage_value(menu_option, sub_menu)}")
  elsif menu_option.include?("reports") or menu_option.include?("requests") or menu_option.include?("notes") or menu_option.include?("tasks")
    page.find(:xpath, "#{report_value(menu_option, sub_menu)}")
  elsif menu_option == "shifts/logs"
    page.find(:xpath, "#{shifts_logs_value(menu_option, sub_menu)}")
  end
end
Given /^a user "(.*?)" with password "(.*?)" exists as role "(.*?)" in "(.*?)" organization$/ do |user, password, role, org|
  fname,lname = user.tableize.singularize.split("_")
  lname =~ /^(\w+)@.*/ 
  user = FactoryGirl.create(:staff, :email=>user, 
                        :password=>password, 
                        :first_name=>fname.capitalize, 
                        :last_name=>$~.captures[0].capitalize)
  level = AccessLevel.find_by_name(role)
  organization = Organization.find_by_display_name(org)
  FactoryGirl.create(:staff_organization, 
                :staff_id=>user.id, 
                :access_level_id=>level.id, 
                :organization_id=>organization.id)
  
end


Then /^I should be on landing page for "(.*?)"$/ do |user| 
  user = Staff.find_by_email(user.downcase)
  name = user.first_name + " " + user.last_name
  /\w+#{name}\w+/.match(
                   find(:xpath, "//div[@id='sign_out_link']//b").text)
  /\w+#{name}'s Unsubmitted Reports/.match(
                   find(:xpath, "//div[@id='inside_container']/h3").text)
end

And /^the following selections should be visible$/ do |selections|
  sel_size = selections.raw.length
  selections.raw
            .flatten
            .slice(1, sel_size)
            .select { |x| find_link(x).visible? }
            .size.should == sel_size - 1
end

Then /^there is a submenu "(.*?)"$/ do |submenu|
  page.has_selector?(:submenu, submenu)
end

Given /^"(.*?)" is logged in with password "(.*?)"$/ do |username, password|
   visit_radar_signin
   login username, password
end



module LoginSteps
  def visit_radar_signin
    visit(Capybara.app_host)
    find_link("Sign In").visible?
  end

  def login (user, password)
    click_link("Sign In")
    page.should have_selector(:xpath, "//form[@id='staff_new']")
    page.should have_selector(:xpath, "//form//label[@for='staff_email']")
    page.should have_selector(:xpath, "//form//label[@for='staff_password']")
    fill_in "staff[email]", :with => user
    fill_in "staff[password]", :with => password
    click_button("Sign in")
    puts "++++++++++++++++++++++++++++++" + user.downcase
    user = Staff.find_by_email(user.downcase)
    name = user.first_name + " " + user.last_name
    /\w+#{name}\w+/.match(
                   find(:xpath, "//div[@id='sign_out_link']//b").text)
    /\w+#{name}'s Unsubmitted Reports/.match(
                   find(:xpath, "//div[@id='inside_container']/h3").text)
  end
end

World(LoginSteps)

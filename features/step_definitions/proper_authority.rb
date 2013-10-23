module RadarEnv
   def set_current_organization(org)
     #@organization = FactroyGirl.create()
     @organization = org
   end
   def get_current_organization
     @organization
   end

   def generate_menu_item(option, sub_option)
     if option == "Manage" || option == "Search" || option == "Tasks"
      "//div[@class='menu']/ul/li/ul/li/a[@href=#{sub_option}"
     end
   end
end

World(RadarEnv)

Given(/^the "(.*?)" organization exists$/) do |org|
  #puts org
  set_current_organization(org) 
  true
end

And(/^the "(.*?)" role exists$/) do |role|
  #puts role
  true
end

And(/^there exists a user "(.*?)" whose password is "(.*?)" with name "(.*?)"$/) do |user, password, name|
  user = FactoryGirl.create(:staff, 
    :email=>user, 
    :password=>password, 
    :first_name=>name.split[0], 
    :last_name=>name.split[1])
end

And(/^"(.*?)" fulfills the "(.*?)" role within the "(.*?)" organization$/) do |user, role, org|
  #puts "[#{get_current_organization}]"
  if (org == "current")
    this_org = get_current_organization
  else
    this_org = Organization.find_by_display_name(org)
  end
    user = Staff.find_by_email(user) rescue false
    level = AccessLevel.find_by_name(role) rescue false

    user.staff_organizations << StaffOrganization.create!(organization_id: this_org.id, access_level_id: level.id) rescue false
  true
end

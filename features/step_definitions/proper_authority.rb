module RadarEnv
   def set_current_organization(org)
     #@organization = FactroyGirl.create()
     @organization = org
   end
   def get_current_organization
     @organization
   end
end

World(RadarEnv)

Given(/^the "(.*?)" organization exists$/) do |org|
  puts org
  set_current_organization(org) 
  true
end

Given(/^the "(.*?)" role exists$/) do |role|
  puts role
  true
end

Given(/^the user "(.*?)" exists with password "(.*?)"$/) do |arg1, arg2|
  true
end


Given(/^"(.*?)" fulfills the "(.*?)" role within the "(.*?)" organization$/) do |user, role, org|
  puts "[#{get_current_organization}]"
  if (org == "current")
    this_org = get_current_organization
  else
    this_org = Organization.find_by_display_name(org)
  end
  # user = Staff.find_by_email(user) rescue false
  # level = AccessLevel.find_by_name(role) rescue false
  # 
  # user.staff_organizations << StaffOrganization.create!(organization_id: this_org.id, access_level_id: level.id) rescue false
  true
end

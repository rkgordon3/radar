module RadarEnv
   def set_current_organization(org)
     @organization = FactoryGirl.create(:residence_life_organization, :display_name=>org)
     #@organization = org
   end

   def get_current_organization
     @organization
   end

   def set_current_access_level(role)
     @role = FactoryGirl.create(:access_level, :name=>role.delete(' '), :display_name=>role)
     puts "name of role = " << @role.name
     #@role = role
   end

   def get_current_access_level
     @role
   end
   
   def top_level_value(option)
    if option.eql?("search")
      path = "participants/%s" % option
    elsif option.eql?("manage") 
      path = "staffs"
    elsif option.eql?("incident reports") or option.eql?("maintenance requests")
      if option.eql?("maintenance requests")
        option.replace("maintenance reports")
      end
      option = option.titlecase.delete(' ')
      path = "reports?report_type=#{option.singularize}"
    elsif option.eql?("notes")
      path = "#{option}/new"
    elsif option.eql?("tasks")
      path = "task_assignments/to_do_list"
    else
      path = "#{option}"
    end
    "//div[@class='menu']/ul/li/a[@href='/#{path}']"
   end

   def search_value(option, sub_option)
     if sub_option.eql?("students")
      path = "participants/%s" % option
     elsif sub_option.eql?("reports")
      path = "#{sub_option}"
     end     
     puts "path %s" % path
      "//div[@class='menu']/ul/li/ul/li/a[@href='/#{path}']"
   end

   def manage_value(option, sub_option)
     if sub_option.eql?("staff members")
      path = "#{sub_option.chomp(" members").pluralize}"
     elsif sub_option.eql?("contact reasons")
      path = "relationship_to_reports"
     else 
      path = "#{sub_option}"
     end
     "//div[@class='menu']/ul/li/ul/li/a[@href='/#{path}']"  
   end

   def report_value(option, sub_option)
     sub_option = sub_option.chomp(" #{option}").strip
     if sub_option.eql?("new task") or sub_option.eql?("new note")
      sub_option = sub_option.chomp(" #{option.singularize}").strip
     end
     puts "After chomping reports, sub_option = " << sub_option
     if option.eql?("maintenance requests")
       option.replace("maintenance reports")
     end
     if sub_option.eql?("list") and !option.eql?("tasks")
      option = option.titlecase.delete(' ')
      path = "reports?report_type=#{option.singularize}"
     elsif sub_option.eql?("new")
      path = "#{option.split(" ").join("_")}/new"
     else
      path = "#{option}"
     end
     "//div[@class='menu']/ul/li/ul/li/a[@href='/#{path}']"  
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
  set_current_access_level(role) 
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
  if (role != "System Administrator")
    user = Staff.find_by_email(user) rescue false
    level = AccessLevel.find_by_display_name(role) rescue false

    user.staff_organizations << FactoryGirl.create(:staff_organization, :organization_id=>this_org.id, :access_level_id=>level.id) rescue false
  end
  true
end

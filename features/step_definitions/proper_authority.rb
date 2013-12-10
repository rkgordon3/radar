module RadarEnv
   def set_current_organization(org)
     @organization = Organization.find_by_display_name(org)
   end

   def get_current_organization
     @organization
   end

   def set_current_user(user)
    @user = user
   end

   def get_current_user
    @user
   end

   def set_current_access_level(role)
     @role = FactoryGirl.create(:access_level, :name=>role.delete(' '), :display_name=>role)
     #@role = role
   end

   def get_current_access_level
     @role
   end
   
   def top_level_value(option)
    if option.eql?("search")
      path = "participants/%s" % option
    elsif option.eql?("manage") 
      if get_current_access_level.name.eql?("CampusSafety") or get_current_access_level.name.eql?("HallDirector") or get_current_access_level.name.eql?("Staff")
        path = ""
      else
        path = "staffs"
      end
    elsif option.eql?("incident reports") or option.eql?("maintenance requests")
      if option.eql?("maintenance requests")
        option.replace("maintenance reports")
      end
      option = option.titlecase.delete(' ')
      path = "reports?report_type=#{option.singularize}"
    elsif option.eql?("notes")
      path = "#{option}/new"
    elsif option.eql?("tasks")
      if get_current_access_level.name.eql?("Staff") or get_current_access_level.name.eql?("ResidentAssistant")
        path= option
      else
        path = "task_assignments/to_do_list"
      end
    elsif option.eql?("shifts/logs")
      path = "shifts?access_level=Any"
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
     if sub_option.eql?("new task") or sub_option.eql?("new note") or sub_option.eql?("new maintenance request") or sub_option.eql?("new incident report")
      sub_option = sub_option.chomp(" #{option.singularize}").strip
     end
     if option.eql?("maintenance requests")
       option.replace("maintenance reports")
     end
     if sub_option.eql?("list") and !option.eql?("tasks")
      option = option.titlecase.delete(' ')
      path = "reports?report_type=#{option.singularize}"
     elsif sub_option.eql?("my to do list")
      path = "task_assignments/to_do_list"
     elsif sub_option.eql?("new")
      path = "#{option.split(" ").join("_")}/new"
     else
      path = "#{option}"
     end
     "//div[@class='menu']/ul/li/ul/li/a[@href='/#{path}']"  
   end

   def shifts_logs_value(option, sub_option)
    if sub_option.eql?("my logs")
      path = "shifts?staff_id=#{get_current_user.id}"
    elsif sub_option.eql?("record shift")
      path ="shifts/new"
    elsif sub_option.eql?("list hd call logs")
      path ="shifts?log_type=call"
    elsif sub_option.eql?("list ra duty logs")
      path ="shifts?log_type=duty"
    end
    "//div[@class='menu']/ul/li/ul/li/a[@href='/#{path}']"
   end
end

World(RadarEnv)

Given(/^the "(.*?)" organization exists$/) do |org|
  set_current_organization(org).should_not be_nil
end

And(/^the "(.*?)" role exists$/) do |role|
  set_current_access_level(role) 
  true
end

And(/^there exists a user "(.*?)" whose password is "(.*?)" with name "(.*?)"$/) do |user, password, name|
  area = FactoryGirl.create(:area, 
    :name => 'Some Area', :abbreviation => 'SA')
  user = FactoryGirl.create(:staff, 
    :email=>user, 
    :password=>password, 
    :first_name=>name.split[0], 
    :last_name=>name.split[1])
  staff_area = FactoryGirl.create(:staff_area, 
    :staff_id => user.id, :area_id => area.id)
  set_current_user(user)
end

And(/^"(.*?)" fulfills the "(.*?)" role within the "(.*?)" organization$/) do |user, role, org|
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

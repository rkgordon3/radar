puts "creating ASC Organization"
asc = Organization.find_by_display_name("Academic Skills Center") ||
       AcademicSkillsCenterOrganization.create(
                                       :display_name => "Academic Skills Center",
                                       :abbreviation => "ASC")
	
puts "Creating 'other' reason for ASC"
other = RelationshipToReport.find_by_description_and_organization_id("Other", asc.id) ||
        RelationshipToReport.create(:description=>"Other", :organization_id=>asc.id)


puts "creating ResLife Organization"
rl = Organization.find_by_display_name("Residence Life") ||
       ResidenceLifeOrganization.create(
                                       :display_name => "Residence Life",
                                       :abbreviation => "RL")

rl.type ||= "ResidenceLifeOrganization"
rl.save


	
# Build report type table
puts 'building report types table'
report_type = ReportType.find_by_name("Report") || 
	ReportType.create!(:name=>"Report", 
                  :abbreviation=>"FYI", 
		  :display_name=>"FYI",
		  :organization_id=>rl.id,
		  :forwardable=>false,
		  :selectable_contact_reasons=>true)
ir_type = ReportType.find_by_name("IncidentReport") || 
	ReportType.create!(:name=>"IncidentReport", 
                  :abbreviation=>"IR", 
		  :display_name=>"Incident Report",
		  :organization_id=>rl.id,
		  :forwardable=>false,
		  :selectable_contact_reasons=>true)
note_type = ReportType.find_by_name("Note") || 
	 ReportType.create!(:name=>"Note", 
                  :abbreviation=>"N", 
		  :display_name=>"Note",
		  :organization_id=>rl.id,
		  :forwardable=>false,
		  :selectable_contact_reasons=>false)
mr_type = ReportType.find_by_name("MaintenanceReport") ||
	ReportType.create!(:name=>"MaintenanceReport", 
                  :abbreviation=>"MR", 
		  :display_name=>"Maintenance Report",
		  :organization_id=>rl.id,
		  :forwardable=>true,
		  :selectable_contact_reasons=>true)


		

# update all existing RTR to be in RL org
# Update existing reasons so that associated with RL org
puts "Attaching existing reasons to reslife org	"
RelationshipToReport.all.each do |rtr|
 rtr.organization_id = rl.id
 rtr.save
end



#TODO: fix this staff org assignments
puts "updating staff_org with access_level"
Staff.all.each { |s|
  unless s.staff_organizations.first.nil?
    so = s.staff_organizations.first
	if so.access_level.nil? # if access_level nil then this update has not been performed
		if not s.access_level.nil?  # if staff access level is nil, this is 'root' and so is trans-organizational
		  org_id = so.organization_id
		  soa = StaffOrganization.delete_all([ "staff_id = ? and organization_id = ?", s.id, so.organization_id])
		  StaffOrganization.create(:staff_id => s.id, 
							:organization_id => org_id, 
							:access_level_id => s.access_level.id)
		end
	end
  end
}

puts "updating reports with org_id"
reslife = Organization.find_by_display_name "Residence Life"
Report.all.each do |r|
  r.organization = reslife
  r.save
end

puts "creating root access level"
root_al = AccessLevel.find_by_name("root") || 
			AccessLevel.create(:name => "root", 
			   	:display_name => "root", 
			   	:numeric_level => 8)
puts "creating sysadmin access level"
system_admin_al = AccessLevel.find_by_name("SystemAdministrator") ||
			AccessLevel.create(:name => "SystemAdministrator", 
			  	:display_name => "System Administrator", 
			   	:numeric_level => 7)
AccessLevel.find_by_name("CampusSafety") || AccessLevel.create!(:name=>"CampusSafety", :display_name=>"Campus Safety")
AccessLevel.find_by_name("ResidentAssistant") || AccessLevel.create!(:name=>"ResidentAssistant", :display_name=>"Resident Assistant")
AccessLevel.find_by_name("HallDirector") || AccessLevel.create!(:name=>"HallDirector", :display_name=>"Hall Director")
AccessLevel.find_by_name("AdministrativeAssistant") || AccessLevel.create!(:name=>"AdministrativeAssistant", :display_name=>"Administrative Assistant")
AccessLevel.find_by_name("Administrator") || AccessLevel.create!(:name=>"Administrator", :display_name=>"Administrator")

# Create radar-admin "super user"
puts "creating radar-admin"
root = Staff.find_by_email("radar-admin@smumn.edu") || 
		Staff.create(:password=> "password",
            		 :password_confirmation => "password",
			 :email => "radar-admin@smumn.edu",
			 :first_name  => "super", 
			 :last_name => "user",
		         :active => true)

#StaffOrganization.create!(:staff_id => root.id, :access_level_id => root_al.id)

# create system admin for ASC
puts "creating ACS admin"
asc_sys_admin = Staff.find_by_email("asc.system.admin@smumn.edu") ||
	 Staff.create!(:password=> "password", 
             :password_confirmation => "password",
			 :email => "asc.system.admin@smumn.edu",
			 :first_name  => "System", 
			 :last_name => "Admin",
			 :active => true)

puts ' create staff/org for ASC system admin'
StaffOrganization.create!(:staff_id => asc_sys_admin.id, :organization_id => asc.id, :access_level_id => system_admin_al.id) if StaffOrganization.find_by_staff_id(asc_sys_admin.id).nil?


puts "creating staff and supervisor access levels"
AccessLevel.find_by_name("Staff") || AccessLevel.create(:name => "Staff", :numeric_level => 99)
puts ' create supervisor'
AccessLevel.find_by_name("Supervisor") || AccessLevel.create(:name => "Supervisor", :numeric_level => 100)

# Runs test seed file that seeds report information, areas, and buildings
load "#{Rails.root}/db/test_seeds.rb"

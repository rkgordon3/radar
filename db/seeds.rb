puts "creating ASC Organization"
asc = Organization.find_by_display_name("Academic Skills Center") ||
       AcademicSkillsCenterOrganization.create(:name => "AcademicSkillsCenter",
                                       :display_name => "Academic Skills Center",
                                       :abbreviation => "ASC")

puts "creating ResLife Organization"
rl = Organization.find_by_display_name("Residence Life") ||
       ResidenceLifeOrganization.create(:name => "ResidenceLife",
                                       :display_name => "Residence Life",
                                       :abbreviation => "RL")

rl.type ||= "ResidenceLifeOrganization"
rl.save

#TODO: fix this staff org assignments
puts "updating staff_org with access_level"
Staff.all.each { |s|
  unless s.staff_organizations.first.nil?
    so = s.staff_organizations.first
	if not so.access_level.nil? # if access_level nil then this update has been performed
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
root_al = AccessLevel.find_by_name("root") || AccessLevel.create(:name => "root", :display_name => "root", :numeric_level => 6)
system_admin_al = AccessLevel.find_by_name("SystemAdministrator")

# Create radar-admin "super user"
puts "creating radar-admin"
root = Staff.find_by_email("radar-admin@smumn.edu") || Staff.create(:password=> "password",
             :password_confirmation => "password",
			 :email => "radar-admin@smumn.edu",
			 :first_name  => "super", :last_name => "user"
)

StaffOrganization.create(:staff_id => root.id, :access_level_id => root_al.id)

# create system admin for ASC
puts "creating ACS admin"
asc_sys_admin = Staff.create(:password=> "password", 
             :password_confirmation => "password",
			 :email => "asc.system.admin@smumn.edu",
			 :first_name  => "System", :last_name => "Admin"
) || Staff.find_by_email("asc.system.admin@smumn.edu")

# create staff/org for ASC system admin
StaffOrganization.create(:staff_id => asc_sys_admin.id, :organization_id => asc.id, :access_level_id => system_admin_al.id) if StaffOrganization.find_by_staff_id(asc_sys_admin.id).nil?

# create staff
puts "creating staff and supervisor access levels"
AccessLevel.find_by_name("Staff") || AccessLevel.create(:name => "Staff", :numeric_level => 99)
# create supervisor
AccessLevel.find_by_name("Supervisor") || AccessLevel.create(:name => "Supervisor", :numeric_level => 100)

puts "creating tutor report"
ReportType.create( { 
  :name=> 'TutorReport' , 
  :display_name => 'Tutor Report', 
  :abbreviation=> 'TR',
  :organization_id => asc.id, 
  :selectable_contact_reasons => true, 
  :has_contact_reason_details => true,
  :forwardable => false,
  :edit_on_mobile => false,
  :submit_on_mobile => false,
  :path_to_reason_context => 'Enrollment',
  :reason_context => 'Course' }) if ReportType.find_by_name("TutorReport").nil?


puts "creating tutor by appointment report"
ReportType.create( { 
  :name=> 'TutorByAppointmentReport' , 
  :display_name => 'By Appointment Tutor Report', 
  :abbreviation=> 'TBA',
  :organization_id => asc.id, 
  :selectable_contact_reasons => true, 
  :has_contact_reason_details => true,
  :forwardable => false,
  :edit_on_mobile => false,
  :submit_on_mobile => false,
  :path_to_reason_context => 'Enrollment',
  :reason_context => 'Course' }) if ReportType.find_by_name("TutorByAppointmentReport").nil?

puts "update Report select/submit/edit attributes"
report = ReportType.find_by_name("Report")
report.edit_on_mobile = false
report.submit_on_mobile = true
report.selectable_contact_reasons = false
report.has_contact_reason_details = false
report.save


puts "update Incident Report select/submit/edit attributes"
report = ReportType.find_by_name("IncidentReport") 
puts " updating IncidentReport type properties"

report.edit_on_mobile = true
report.submit_on_mobile = false
report.selectable_contact_reasons = true
report.has_contact_reason_details = false
report.save

puts "creating report fields for incident report"

ReportField.create( {
  :report_type_id => report.id,
  :name => 'building',
  :edit_position => 1,
  :index_position => 5,
  :search_position => 1,
  :show_position => 3 } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'specific_location',
  :edit_position => 2,
  :index_position => 6,
  :show_position => 4 } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'approach_datetime',
  :edit_position => 3
  } )

ReportField.create( {
  :report_type_id => report.id,
  :name => 'secondary_submitters',
  :edit_position => 4,
  :show_position => 7
 } )
 
  
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'area',
  :search_position => 2,
 } )
 
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'student_search',
  :search_position => 3,
 } )
 
ReportField.create( {
  :report_type_id => report.id,
  :name => 'reason',
  :search_position => 4,
 } )
 
ReportField.create( {
  :report_type_id => report.id,
  :name => 'date',
  :index_position => 1,
  :show_position => 1 } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'time',
  :index_position => 2,
  :show_position => 2 } )
  
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'tag',
  :index_position => 3 })
  
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'staff',
  :index_position =>4,
  :show_position => 6 })
  
    
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'annotation',
  :show_position => 5 } )
    
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'created_at',
  :show_position => 9  } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'updated_at',
  :show_position => 10  } )

puts "update MaintenanceReport  select/submit/edit attributes"
report = ReportType.find_by_name("MaintenanceReport")
report.edit_on_mobile = false
report.submit_on_mobile = true
report.selectable_contact_reasons = false
report.has_contact_reason_details = false
report.save

puts "creating report fields for maintenance report"
ReportField.create( {
  :report_type_id => report.id,
  :name => 'building',
  :edit_position => 1,
  :index_position => 5,
  :search_position => 1,
  :show_position => 3 } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'specific_location',
  :edit_position => 2,
  :index_position => 6,
  :show_position => 4 } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'approach_datetime',
  :edit_position => 3
  } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'secondary_submitters',
  :edit_position => 4,
 } )
 
  
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'area',
  :search_position => 2,
 } )
 
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'student_search',
  :search_position => 3,
 } )
 
ReportField.create( {
  :report_type_id => report.id,
  :name => 'reason',
  :search_position => 4,
 } )
 
ReportField.create( {
  :report_type_id => report.id,
  :name => 'date',
  :index_position => 1,
  :show_position => 1 } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'time',

  :index_position => 2,
  :show_position => 2 } )
  
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'tag',
  :index_position => 3 })
  
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'staff',
  :index_position =>4,
  :show_position => 6 })
  
    
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'annotation',
  :show_position => 5 } )
     
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'created_at',
  :show_position => 9  } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'updated_at',
  :show_position => 10  } )


puts "creating report fields for tutor report"
report = ReportType.find_by_name("TutorReport")


 ReportField.create( {
  :report_type_id => report.id,
  :name => 'approach_datetime',
  :edit_position => 3,
 } ) 
 
  ReportField.create( {
  :report_type_id => report.id,
  :name => 'annotation',
  :show_position => 3,
 } ) 
 
  ReportField.create( {
  :report_type_id => report.id,
  :name => 'staff',
  :show_position => 6,
 } ) 

puts "creating report fields for tutor-by-app report"
 report = ReportType.find_by_name("TutorByAppointmentReport")


 ReportField.create( {
  :report_type_id => report.id,
  :name => 'approach_datetime',
  :edit_position => 3,
 } ) 
 
  ReportField.create( {
  :report_type_id => report.id,
  :name => 'annotation',
  :show_position => 3,
 } ) 
 
  ReportField.create( {
  :report_type_id => report.id,
  :name => 'staff',
  :show_position => 6,
 } ) 

 
puts "update MaintenanceReport  select/submit/edit attributes"

report = ReportType.find_by_name("Note") 
report.edit_on_mobile = false
report.submit_on_mobile = true
report.selectable_contact_reasons = false
report.has_contact_reason_details = false
report.save 

puts "creating report fields for note"
ReportField.create( {
  :report_type_id => report.id,
  :name => 'date',
  :index_position => 1,
  :show_position => 1 } )
  
ReportField.create( {
  :report_type_id => report.id,
  :name => 'time',
  :index_position => 2,
  :show_position => 2 } )
  
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'tag',
  :index_position => 3 })
  
 ReportField.create( {
  :report_type_id => report.id,
  :name => 'staff',
  :index_position =>4,
  :show_position => 6 })
  
  ReportField.create( {
  :report_type_id => report.id,
  :name => 'annotation',
  :index_position => 5 } )
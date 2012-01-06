root_al = AccessLevel.find_by_name("root") || AccessLevel.create(:name => "root", display_name => "root", :numeric_level => 6) 
system_admin_al = AccessLevel.find_by_name("SystemAdministrator")

# Create radar-amdmin "super user"
Staff.create(:password=> "password", 
             :password_confirmation => "password",
			 :email => "radar-smumn.edu",
			 :first_name  => "super", :last_name => "user",
			 :access_level_id => root_al.id
) if Staff.find_by_email("radar-admin@smumn.edu").nil?

# create system admin for ASC			 
asc_sys_admin = Staff.create(:password=> "password", 
             :password_confirmation => "password",
			 :email => "asc.system.admin@smumn.edu",
			 :first_name  => "System", :last_name => "Admin",
			 :access_level_id => system_admin_al.id
) || Staff.find_by_email("asc.system.admin@smumn.edu")

asc = Organization.find_by_type("AcademicSkillsCenterOrganization")

# create staff/org for ASC system admin
StaffOrganization.create(:staff_id => asc_sys_admin.id, :organization_id => asc.id) if StaffOrganization.find_by_staff_id(asc_sys_admin.id).nil?

# create staff
AccessLevel.find_by_name("Staff") || AccessLevel.create(:name => "Staff", :numeric_level => 99)
# create supervisor
AccessLevel.find_by_name("Supervisor") || AccessLevel.create(:name => "Supervisor", :numeric_level => 100)
			 
ReportType.create( { 
  :name=> 'TutorReport' , 
  :display_name => 'Tutor Report', 
  :abbreviation=> 'TR',
  :organization_id => asc.id, 
  :selectable_contact_reasons => true, 
  :has_contact_reason_details => true,
  :path_to_reason_context => 'Enrollment',
  :reason_context => 'Course' }) if ReportType.find_by_name("TutorReport").nil?


  
ReportType.create( { 
  :name=> 'TutorByAppointmentReport' , 
  :display_name => 'By Appointment Tutor Report', 
  :abbreviation=> 'TBA',
  :organization_id => asc.id, 
  :selectable_contact_reasons => true, 
  :has_contact_reason_details => true,
  :path_to_reason_context => 'Enrollment',
  :reason_context => 'Course' }) if ReportType.find_by_name("TutorByAppointmentReport").nil?

report = ReportType.find_by_name("IncidentReport") 

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
  
report = ReportType.find_by_name("MaintenanceReport") 


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



report = ReportType.find_by_name("TutorReport")


 ReportField.create( {
  :report_type_id => report.id,
  :name => 'approach_datetime',
  :edit_position => 3,
 } ) 
  
  
report = ReportType.find_by_name("Note") 

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
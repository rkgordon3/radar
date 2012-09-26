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

puts 'building Relationship to report table'
RelationshipToReport.find_by_description("Community Disruption") ||
	RelationshipToReport.create!(:description=>"Community Disruption",
		:report_type => ir_type,
		:organization_id=> rl.id)
RelationshipToReport.find_by_description("Smoking") ||
	RelationshipToReport.create!(:description=>"Smoking",
		:report_type => ir_type,
		:organization_id=> rl.id)
RelationshipToReport.find_by_description("Alcohol(Underage)") ||
	RelationshipToReport.create!(:description=>"Alcohol(Underage)",
		:report_type => ir_type,
		:organization_id=> rl.id)
RelationshipToReport.find_by_description("FYI") ||
	RelationshipToReport.create!(:description=>"FYI",
		:report_type => ir_type,
		:organization_id=> rl.id)
RelationshipToReport.find_by_description("Maintenance Concern") ||
	RelationshipToReport.create!(:description=>"Maintenance Concern",
		:report_type => ir_type,
		:organization_id=> rl.id)
		

# update all existing RTR to be in RL org
# Update existing reasons so that associated with RL org
puts "Attaching existing reasons to reslife org	"
RelationshipToReport.all.each do |rtr|
 rtr.organization_id = rl.id
 rtr.save
end
puts "update default reason for MR"
mr = ReportType.find_by_name("MaintenanceReport")
mr.default_reason_id = RelationshipToReport.where(:description=>"Maintenance Concern", :organization_id => rl.id).first.id
mr.save

puts "update default reason for IR"
ir = ReportType.find_by_name("IncidentReport")
ir.default_reason_id = RelationshipToReport.where(:description=>"FYI", :organization_id => rl.id).first.id
ir.save

puts "update default reason for Note"
ir = ReportType.find_by_name("Note")
ir.default_reason_id = RelationshipToReport.where(:description=>"FYI", :organization_id => rl.id).first.id
ir.save

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

# Create areas on campus
puts "creating areas on campus"
na = Area.find_by_name("Unspecified") || Area.create(:name=>'Unspecified', :abbreviation=>'NA')
hesk = Area.find_by_name("Heffron, Skemp") || Area.create(:name=>'Heffron, Skemp', :abbreviation=>'HESK')
wek = Area.find_by_name("Watters, Ek Family Village") || Area.create(:name=>'Watters, Ek Family Village', :abbreviation=>'WEK')
rsmb = Area.find_by_name("Residencia Santiago Miller, Brother Leopold") || Area.create(:name=>'Residencia Santiago Miller, Brother Leopold', :abbreviation=>'RSMB')
hgc = Area.find_by_name("Hillside, Gilmore Creek") || Area.create(:name=>'Hillside, Gilmore Creek', :abbreviation=>'HGC')
bny = Area.find_by_name("Benilde, St. Yons") || Area.create(:name=>'Benilde, St. Yons', :abbreviation=>'BNY')
jp = Area.find_by_name("St. Josephs, Pines") || Area.create(:name=>'St. Josephs, Pines', :abbreviation=>'JP')
ls = Area.find_by_name("LaSalle") || Area.create(:name=>'LaSalle', :abbreviation=>'LS')
eds = Area.find_by_name("St. Edwards") || Area.create(:name=>'St. Edwards', :abbreviation=>'EDS')


# Create building
puts "creating buildings for specified areas"
Building.find_by_name("Unspecified") || Building.create(:name=>"Unspecified", :abbreviation=>"NA", :area_id => na.id)
Building.find_by_name("Off Campus") || Building.create(:name=>'Off Campus', :abbreviation=>'OFFCAM', :area_id=>na.id)
Building.find_by_name("Athletic Fields") || Building.create(:name=>'Athletic Fields', :abbreviation=>'ATHL', :area_id=>na.id)
Building.find_by_name("Jul Gernes Pool") || Building.create(:name=>'Jul Gernes Pool', :abbreviation=>'POOL', :area_id=>na.id)
Building.find_by_name("Gostomski Fieldhouse") || Building.create(:name=>'Gostomski Fieldhouse', :abbreviation=>'GF', :area_id=>na.id)
Building.find_by_name("Gym/Hall of Fame Room") || Building.create(:name=>'Gym/Hall of Fame Room', :abbreviation=>'GYM', :area_id=>na.id)
Building.find_by_name("Hendrickson Center") || Building.create(:name=>'Hendrickson Center', :abbreviation=>'HC', :area_id=>na.id)
Building.find_by_name("Ice Arena") || Building.create(:name=>'Ice Arena', :abbreviation=>'ICE', :area_id=>na.id)
Building.find_by_name("IHM Seminary") || Building.create(:name=>'IHM Seminary', :abbreviation=>'IHM', :area_id=>na.id)
Building.find_by_name("Fitzgerald Library") || Building.create(:name=>'Fitzgerald Library', :abbreviation=>'LIB', :area_id=>na.id)
Building.find_by_name("Pedestrian Overpass") || Building.create(:name=>'Pedestrian Overpass', :abbreviation=>'PED', :area_id=>na.id)
Building.find_by_name("Power Plan/Clock Tower") || Building.create(:name=>'Power Plant/Clock Tower', :abbreviation=>'PPL', :area_id=>na.id)
Building.find_by_name("Plaza") || Building.create(:name=>'Plaza', :abbreviation=>'PLZ', :area_id=>na.id)
Building.find_by_name("Performance Center") || Building.create(:name=>'Performance Center', :abbreviation=>'PC', :area_id=>na.id)
Building.find_by_name("RAC") || Building.create(:name=>'RAC', :abbreviation=>'RAC', :area_id=>na.id)
Building.find_by_name("Saint Marys Hall") || Building.create(:name=>'Saint Marys Hall', :abbreviation=>'SM', :area_id=>na.id)
Building.find_by_name("Saint Thomas More Chapel") || Building.create(:name=>'Saint Thomas More Chapel', :abbreviation=>'CHAP', :area_id=>na.id)
Building.find_by_name("St. Yons Valley/X-Country Trails") || Building.create(:name=>'St. Yons Valley/X-Country Trails', :abbreviation=>'XCT', :area_id=>na.id)
Building.find_by_name("Intramural Fields") || Building.create(:name=>'Intramural Fields', :abbreviation=>'INTF', :area_id=>na.id)
Building.find_by_name("Michael H. Toner Student Center") || Building.create(:name=>'Michael H. Toner Student Center', :abbreviation=>'TON', :area_id=>na.id)
Building.find_by_name("Skemp Hall") || Building.create(:name=>'Skemp Hall', :abbreviation=>'SK', :area_id=>hesk.id, :is_residence=>true)
Building.find_by_name("Heffron Hall") || Building.create(:name=>'Heffron Hall', :abbreviation=>'HE', :area_id=>hesk.id, :is_residence=>true)
Building.find_by_name("LaSalle Hall") || Building.create(:name=>'LaSalle Hall', :abbreviation=>'LS', :area_id=>ls.id, :is_residence=>true)
Building.find_by_name("St. Edwards Hall") || Building.create(:name=>'St. Edwards Hall', :abbreviation=>'SE', :area_id=>eds.id, :is_residence=>true)
Building.find_by_name("Watters Hall") || Building.create(:name=>'Watters Hall', :abbreviation=>'WT', :area_id=>wek.id, :is_residence=>true)
Building.find_by_name("Ek Family Village") || Building.create(:name=>'Ek Family Village', :abbreviation=>'EV', :area_id=>wek.id, :is_residence=>true)
Building.find_by_name("Residencia Santiago Miller") || Building.create(:name=>'Residencia Santiago Miller', :abbreviation=>'RSM', :area_id=>rsmb.id, :is_residence=>true)
Building.find_by_name("Brother Leopold Hall") || Building.create(:name=>'Brother Leopold Hall', :abbreviation=>'BRO', :area_id=>rsmb.id, :is_residence=>true)
Building.find_by_name("Gilmore Creek Hall") || Building.create(:name=>'Gilmore Creek Hall', :abbreviation=>'GC', :area_id=>hgc.id, :is_residence=>true)
Building.find_by_name("St. Benilde Hall") || Building.create(:name=>'St. Benilde Hall', :abbreviation=>'BN', :area_id=>bny.id, :is_residence=>true)
Building.find_by_name("St. Yons Hall") || Building.create(:name=>'St. Yons Hall', :abbreviation=>'SY', :area_id=>bny.id, :is_residence=>true)
Building.find_by_name("St. Josephs Hall") || Building.create(:name=>'St. Josephs Hall', :abbreviation=>'STJO', :area_id=>jp.id, :is_residence=>true)
Building.find_by_name("The Pines Hall") || Building.create(:name=>'The Pines Hall', :abbreviation=>'PI', :area_id=>jp.id, :is_residence=>true)
Building.find_by_name("Hillside Hall") || Building.create(:name=>'Hillside Hall', :abbreviation=>'HI', :area_id=>hgc.id, :is_residence=>true)
Building.find_by_name("My Building Hall") || Building.create(:name=>'My Building', :abbreviation=>'MYB', :area_id=>na.id)


# Create radar-admin "super user"
puts "creating radar-admin"
root = Staff.find_by_email("radar-admin@smumn.edu") || 
		Staff.create(:password=> "password",
            		 :password_confirmation => "password",
			 :email => "radar-admin@smumn.edu",
			 :first_name  => "super", 
			 :last_name => "user",
		         :active => true)

StaffOrganization.create!(:staff_id => root.id, :access_level_id => root_al.id)

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

puts "creating tutor report"
tr = ReportType.find_by_name("TutorReport") || ReportType.create( { 
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
  :default_reason_id => other.id,
  :reason_context => 'Course' }) 
  
if tr.default_reason_id.nil?
puts 'update default contact id for TR'
 tr.default_reason_id = other_id
 tr.save
end

tst = ReportType.find_by_name("TutorStudyTableReport") || ReportType.create( { 
  :name=> 'TutorStudyTableReport' , 
  :display_name => 'Study Table Tutor Report', 
  :abbreviation=> 'TST',
  :organization_id => asc.id, 
  :selectable_contact_reasons => true, 
  :has_contact_reason_details => true,
  :forwardable => false,
  :edit_on_mobile => false,
  :submit_on_mobile => false,
  :path_to_reason_context => 'Enrollment',
  :default_reason_id => other.id,
  :reason_context => 'Course' }) 

puts "creating tutor by appointment report"
tba = ReportType.find_by_name("TutorByAppointmentReport") || ReportType.create( { 
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
  :default_reason_id => other.id,
  :reason_context => 'Course' }) 
  
  puts "creating tutor drop in report"
dit = ReportType.find_by_name("TutorDropInReport") || ReportType.create( { 
  :name=> 'TutorDropInReport' , 
  :display_name => 'Drop In Tutor Report', 
  :abbreviation=> 'DIT',
  :organization_id => asc.id, 
  :selectable_contact_reasons => true, 
  :has_contact_reason_details => true,
  :forwardable => false,
  :edit_on_mobile => false,
  :submit_on_mobile => false,
  :path_to_reason_context => 'Enrollment',
  :default_reason_id => other.id,
  :reason_context => 'Course' }) 
  
    
if tba.default_reason_id.nil?
puts 'update default contact id for TBA'
 tba.default_reason_id = other_id
 tba.save
end

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

 puts "creating report fields for study table report"
 report = ReportType.find_by_name("TutorStudyTableReport")


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
 
 puts "creating report fields for drop in report"
 report = ReportType.find_by_name("TutorDropInReport")
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
  :index_position => 1 } )
  

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
  :show_position => 3,
  :index_position => 5 } )
  
  ReportField.create( {
  :report_type_id => report.id,
  :name => 'building',
  :edit_position => 4,
  :show_position => 4 } )
  
  ReportField.create( {
  :report_type_id => report.id,
  :name => 'specific_location',
  :edit_position => 5,
  :show_position => 5 } )
  
  

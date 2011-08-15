reslife = Organization.create(:id=>1, :name=>"ResidenceLife", :display_name=>"Residence Life", :abbreviation=>"RL")

# Incident Report

ir = ReportType.create(:id=>1, :name=>"IncidentReport", :display_name=>"Incident Report", :abbreviation=>"IR", :organization_id=>reslife.id, :forwardable=>"f")

# Incident Report 'reasons'
RelationshipToReport.create(:id=>1, :description=>"Community Disruption", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>2, :description=>"Smoking", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>3, :description=>"Alcohol (Underage)", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>4, :description=>"Alcohol (Of Age)", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>5, :description=>"Intoxication", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>6, :description=>"Paraphernalia (Alcohol)", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>7, :description=>"Fire Safety", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>8, :description=>"Vandalism", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>9, :description=>"Privacy Hours", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>10, :description=>"Non-Compliance", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>11, :description=>"Hosted Large Party", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>12, :description=>"Drugs", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>13, :description=>"Paraphernalia (Drugs)", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>14, :description=>"Mental Health Concern", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>15, :description=>"Hosting of Minors", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>16, :description=>"Binge Drinking Situation/Drinking Games", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>17, :description=>"Weapon", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>18, :description=>"Public Urination", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>19, :description=>"Physical Fight/Assault", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>20, :description=>"Threats/Harrassment", :report_type_id=>ir.id)
RelationshipToReport.create(:id=>20, :description=>"FYI")
RelationshipToReport.create(:id=>20, :description=>"Other")

# Maintenance Report 
mr = ReportType.create(:id=>2, :name=>"MaintenanceReport", :display_name=>"Maintenance Report", :abbreviation=>"MR", :organization_id=>reslife.id, :forwardable=>"t")

# Maintenance Report reasons
RelationshipToReport.create(:id=>23, :description=>"Maintenance Concern", :report_type_id=>mr.id)

# Maintenance Report forwarding addresses
InterestedParty.create(:id=>1, :email=>"Helpdesk <helpdesk@smumn.edu>", :report_type_id=>mr.id)
InterestedParty.create(:id=>2, :email=>"Maintenance <smoger@smumn.edu>", :report_type_id=>mr.id)

ReportType.create(:id=>3, :name=>"Report", :display_name=>"FYI", :abbreviation=>"FYI", :organization_id=>reslife.id, :forwardable=>"f")

# Areas and Buildings

ar = Area.create(:id=>1, :name=>"Unspecified", :abbreviation=>"NA")
unspec_area = ar
Building.create(:id=>1, :name=>"Unspecified", :area_id=>1, :abbreviation=>"NA")
Building.create(:id=>16, :name=>"Off Campus", :area_id=>ar.id, :abbreviation=>"OC")
Building.create(:id=>17, :name=>"Athletic Fields", :area_id=>ar.id, :abbreviation=>"ATHL")
Building.create(:id=>18, :name=>"Jul Gernes Pool", :area_id=>ar.id, :abbreviation=>"POOL")
Building.create(:id=>19, :name=>"Gostomski Fieldhouse", :area_id=>ar.id, :abbreviation=>"GF")
Building.create(:id=>20, :name=>"Gym/Hall of Fame Room", :area_id=>ar.id, :abbreviation=>"GYM")
Building.create(:id=>21, :name=>"Hendrickson Center", :area_id=>ar.id, :abbreviation=>"HC")
Building.create(:id=>22, :name=>"Ice Arena", :area_id=>ar.id, :abbreviation=>"ICE")
Building.create(:id=>23, :name=>"IHM Seminary", :area_id=>ar.id, :abbreviation=>"IHM")
Building.create(:id=>24, :name=>"Fitzgerald Library", :area_id=>ar.id, :abbreviation=>"LIB")
Building.create(:id=>25, :name=>"Pedestrian Overpass", :area_id=>ar.id, :abbreviation=>"PED")
Building.create(:id=>26, :name=>"Power Plant/Clock Tower", :area_id=>ar.id, :abbreviation=>"PPL")
Building.create(:id=>27, :name=>"Plaza", :area_id=>ar.id, :abbreviation=>"PLZ")
Building.create(:id=>28, :name=>"Performance Center", :area_id=>ar.id, :abbreviation=>"PC")
Building.create(:id=>29, :name=>"RAC", :area_id=>ar.id, :abbreviation=>"RAC")
Building.create(:id=>30, :name=>"Saint Marys Hall", :area_id=>ar.id, :abbreviation=>"SM")
Building.create(:id=>31, :name=>"Saint Thomas More Chapel", :area_id=>ar.id, :abbreviation=>"CHAP")
Building.create(:id=>32, :name=>"St. Yon's Valley/X-Country Trails", :area_id=>ar.id, :abbreviation=>"XCT")
Building.create(:id=>33, :name=>"Intramural Fields", :area_id=>ar.id, :abbreviation=>"INTF")
Building.create(:id=>34, :name=>"Michael H. Toner Student Center", :area_id=>ar.id, :abbreviation=>"TON")

ar = Area.create(:id=>1, :name=>"Skemp, Heffron, La Salle", :abbreviation=>"SKHELS")
Building.create(:id=>2, :name=>"Skemp Hall", :area_id=>ar.id, :abbreviation=>"SK")
Building.create(:id=>3, :name=>"Heffron Hall", :area_id=>ar.id, :abbreviation=>"HE")
Building.create(:id=>4, :name=>"La Salle Hall", :area_id=>ar.id, :abbreviation=>"LS")

ar = Area.create(:id=>1, :name=>"St. Edward's, Vlazny", :abbreviation=>"VLEDS")
Building.create(:id=>5, :name=>"St. Edward Hall", :area_id=>ar.id, :abbreviation=>"SE")
Building.create(:id=>6, :name=>"Vlazny Hall", :area_id=>ar.id, :abbreviation=>"VL")

ar = Area.create(:id=>1, :name=>"Waters, Ek Village, New Village", :abbreviation=>"WILLAGES")
Building.create(:id=>7, :name=>"Watters Hall", :area_id=>ar.id, :abbreviation=>"WT")
Building.create(:id=>8, :name=>"Ek Village", :area_id=>ar.id, :abbreviation=>"EV")
Building.create(:id=>9, :name=>"New Village", :area_id=>ar.id, :abbreviation=>"NV")
willages_area = ar

ar = Area.create(:id=>1, :name=>"Gilmore Creek, Benilde, St. Yon's", :abbreviation=>"GCBY")
Building.create(:id=>10, :name=>"Gilmore Creek Hall", :area_id=>ar.id, :abbreviation=>"GC")
Building.create(:id=>11, :name=>"St. Benilde Hall", :area_id=>ar.id, :abbreviation=>"SB")
Building.create(:id=>12, :name=>"St. Yons Hall", :area_id=>ar.id, :abbreviation=>"SY")

ar = Area.create(:id=>1, :name=>"St. Joseph's, Pines, Hillside", :abbreviation=>"JPH")
Building.create(:id=>13, :name=>"St. Joseph Hall", :area_id=>ar.id, :abbreviation=>"SJ")
Building.create(:id=>14, :name=>"The Pines Hall", :area_id=>ar.id, :abbreviation=>"PI")
Building.create(:id=>15, :name=>"Hillside Hall", :area_id=>ar.id, :abbreviation=>"HI")
jph_area = ar

# Tasks

Task.create(:id=>1, :title=>"Check in with Hall Director", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>2, :title=>"Wearing Polo", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>3, :title=>"Radio Check after Second Round", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>4, :title=>"Check Fire Safety Equipment", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>5, :title=>"Check Kitchens", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>6, :title=>"Check Lounges", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>7, :title=>"Check Bathrooms/Showers", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>8, :title=>"Check Computer Labs", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>9, :title=>"Check Laundry Rooms", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>10, :title=>"Check Exit Doors", :area_id=>unspec_area.id, :note =>"Make Sure All Doors Are Unpropped", :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>11, :title=>"Check Classrooms", :area_id=>jph_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>12, :title=>"Check Parking Lots", :area_id=>willages_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>13, :title=>"New Village/Old Village Path Walk Completed", :area_id=>willages_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)
Task.create(:id=>14, :title=>"Radio Sign Off", :area_id=>unspec_area.id, :start_date=>DateTime.now, :end_date=>DateTime.now, :expires=>"f", :time=>-1)

# Access Levels
AccessLevel.create(:name=>"ResidentAssistant", :display_name=> "Resident Assistant", :numeric_level=>1)
AccessLevel.create(:name=>"HallDirector", :display_name=> "Hall Director", :numeric_level=>2)
AccessLevel.create(:name=>"AdiministrativeAssistant", :display_name=> "Adiministrative Assistant", :numeric_level=>3)
AccessLevel.create(:name=>"Adiministrator", :display_name=> "Adiministrator", :numeric_level=>4)
sys_admin_al = AccessLevel.create(:name=>"SystemAdiministrator", :display_name=> "System Adiministrator", :numeric_level=>5)

# Staff (populate with system.admin)
sys_admin = Staff.create(:email=>"reslife.system.admin@smumn.edu", 
             :encrypted_password=>"$2a$10$IghfYLOEKBMlPm4Z2dAGYe.r.65gmWIpDSyjMc7WMLNIJGKa3K276",
             :password_salt=>"$2a$10$IghfYLOEKBMlPm4Z2dAGYe",
             :access_level_id=>sys_admin_al.id,
             :active=>true)
             
# Staff_Organizations (add radar.system.admin)
StaffOrganization.create(:staff_id=>sys_admin.id, :organization_id=>reslife.id)

# StaffArea (put system.admin in area)
StaffArea.create(:staff_id=>sys_admin.id, :area_id=>unspec_area.id)
   

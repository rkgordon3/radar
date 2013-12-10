module SeedsHelper

	def create_rl_reports(rl, default)
  puts "update Report select/submit/edit attributes"
  report = ReportType.find_by_name("Report")  ||
  	ReportType.create!(:name=>"Report", 
                    :abbreviation=>"FYI", 
  		  :display_name=>"FYI",
  		  :organization_id=>rl.id,
  		  :forwardable=>false,
  		  :selectable_contact_reasons=>true)
  report.edit_on_mobile = false
  report.submit_on_mobile = true
  report.selectable_contact_reasons = false
  report.has_contact_reason_details = false
  report.save


  puts "update Incident Report select/submit/edit attributes"
  report = ReportType.find_by_name("IncidentReport")  ||
  	ReportType.create!(:name=>"IncidentReport", 
                    :abbreviation=>"IR", 
  		  :display_name=>"Incident Report",
  		  :organization_id=>rl.id,
  		  :forwardable=>false,
  		  :selectable_contact_reasons=>true)
  puts "updating IncidentReport type properties"

  report.edit_on_mobile = true
  report.submit_on_mobile = false
  report.selectable_contact_reasons = true
  report.has_contact_reason_details = false

  puts "update default reason for IR"

  report.default_reason_id = default.id

  report.save
  puts "creating report fields for incident report"
  create_ir_fields(report)
  create_ir_infractions(report, rl)


  puts "update MaintenanceReport  select/submit/edit attributes"
  report = ReportType.find_by_name("MaintenanceReport") ||
  	ReportType.create!(:name=>"MaintenanceReport", 
                    :abbreviation=>"MR", 
  		  :display_name=>"Maintenance Report",
  		  :organization_id=>rl.id,
  		  :forwardable=>true,
  		  :selectable_contact_reasons=>true)
  report.edit_on_mobile = false
  report.submit_on_mobile = true
  report.selectable_contact_reasons = false
  report.has_contact_reason_details = false

  puts "update default reason for MR"


  mr_default = RelationshipToReport.where(:description=>"Maintenance Concern", :organization_id => rl.id).first ||
  RelationshipToReport.create(:description=>"Maintenance Concern", :organization_id => rl.id)
	report.default_reason_id =  mr_default.id

  report.save

  create_mr_fields(report)

  puts "update Note  select/submit/edit attributes"

  report = ReportType.find_by_name("Note")  ||
     ReportType.create!(:name=>"Note", 
                    :abbreviation=>"N", 
        :display_name=>"Note",
        :organization_id=>rl.id,
        :forwardable=>false,
        :selectable_contact_reasons=>false)
  report.edit_on_mobile = false
  report.submit_on_mobile = true
  report.selectable_contact_reasons = false
  report.has_contact_reason_details = false
   puts "update default reason for Note"

  report.default_reason_id = default.id

  report.save 

  create_note_fields(report)

end

def create_note_fields(report)
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

end
  
  

  
def create_mr_fields(report) 
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

end

def create_ir_fields(report)
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

end

def create_ir_infractions(ir_type, org)
puts 'building Relationship to report table'
RelationshipToReport.find_by_description("Community Disruption") ||
	RelationshipToReport.create!(:description=>"Community Disruption",
		:report_type => ir_type,
		:organization_id=> org.id)
RelationshipToReport.find_by_description("Smoking") ||
	RelationshipToReport.create!(:description=>"Smoking",
		:report_type => ir_type,
		:organization_id=> org.id)
RelationshipToReport.find_by_description("Alcohol(Underage)") ||
	RelationshipToReport.create!(:description=>"Alcohol(Underage)",
		:report_type => ir_type,
		:organization_id=> org.id)
RelationshipToReport.find_by_description("FYI") ||
	RelationshipToReport.create!(:description=>"FYI",
		:report_type => ir_type,
		:organization_id=> org.id)
RelationshipToReport.find_by_description("Maintenance Concern") ||
	RelationshipToReport.create!(:description=>"Maintenance Concern",
		:report_type => ir_type,
		:organization_id=> org.id)

end



def create_asc_reports(asc, default) 

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
	  :default_reason_id => default.id,
	  :reason_context => 'Course' }) 
  

  	create_tr_fields(tr)

	if tr.default_reason_id.nil?
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
	  :default_reason_id => default.id,
	  :reason_context => 'Course' }) 

	create_ts_fields(tst)

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
	  :default_reason_id => default.id,
	  :reason_context => 'Course' }) 

	create_tba_fields(tba)
	  
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
	  :default_reason_id => default.id,
	  :reason_context => 'Course' }) 
  
    create_di_fields(dit)
	  if tba.default_reason_id.nil?
	   tba.default_reason_id = other_id
	   tba.save
	  end
end

def create_ts_fields(report)
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
 end
def create_di_fields(report)
 puts "creating report fields for drop in report"

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

end


def create_tba_fields(report)

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

end

def create_tr_fields(report)
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

end



end

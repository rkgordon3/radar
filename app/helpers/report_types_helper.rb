module ReportTypesHelper

  def self.all_id
    -1
  end
  #
  # Present array iof [report name, id] plus placehold for "All" to view
  #
  def self.for_select    
    types = ReportType.all.collect { |rt| [ rt.display_name, rt.id ] }	
	types << [self.all_label, self.all_id.to_s ]
  end
  
  def self.all_label
	"All"
  end

  def self.default_selection
    ReportType.find_by_abbreviation(DEFAULT_REPORT_ABBREV).id.to_s
  end
end

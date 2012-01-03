module ReportTypesHelper

  def self.all_id
    -1
  end
  #
  # Present array of [report name, id] plus placehold for "All" to view
  #
  def self.report_types_for(ability)   
    @@types ||= ReportType.accessible_by(ability, :search).collect.sort
  end
  
  def self.all_label
	"All"
  end

  def self.default_selection
    ReportType.find_by_abbreviation(DEFAULT_REPORT_ABBREV).id.to_s
  end
end

class ReportType < ActiveRecord::Base
  has_many :interested_parties
  has_many :report_fields
  
  def controller_name
	name.pluralize.underscore << "_controller"
  end
  
  def fields(view)
    self.report_fields.where("#{view}_position IS NOT NULL and #{view}_position > 0").order("#{view}_position")
  end
end

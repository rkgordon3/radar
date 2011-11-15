class ReportType < ActiveRecord::Base
  has_many :interested_parties
  
  def controller_name
	name.pluralize.underscore << "_controller"
  end
    

end

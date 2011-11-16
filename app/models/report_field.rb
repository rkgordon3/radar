class ReportField < ActiveRecord::Base
    belongs_to :report_type
    
    attr_accessible :name
end

class ReportAdjunct < ActiveRecord::Base
  belongs_to :staff
  belongs_to :report
end

class StaffArea < ActiveRecord::Base
  belongs_to :staff
  belongs_to :area
  
end

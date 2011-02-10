class StudentInfraction < ActiveRecord::Base
	belongs_to :student
	belongs_to :infraction
	belongs_to :report
end

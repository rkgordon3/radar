class Report < ActiveRecord::Base
	belongs_to  	:staff
	belongs_to     	:building
	has_one		:annotation
	
end



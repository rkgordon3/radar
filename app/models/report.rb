class Report < ActiveRecord::Base
	validates_presence_of :type
	belongs_to  	:staff
	belongs_to     	:building
	has_one		:annotation
	
end



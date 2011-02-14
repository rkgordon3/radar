class Report < ActiveRecord::Base
	belongs_to  	:submitter, :class_name => "Staff"
	belongs_to     	:building
	has_many	:annotations
	# will need to delete when we get inheritance working
	has_many	:reported_infractions
end



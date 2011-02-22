class Participant < ActiveRecord::Base
	belongs_to :photo
	
	def full_name
		"#{self.first_name} #{self.last_name}"
	end
end

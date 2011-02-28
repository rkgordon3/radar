class Student < Participant
	belongs_to :building
	
	def full_name
		"#{self.first_name} #{self.last_name}, #{self.building.abbreviation}, #{self.room_number}, #{self.id}"
		end
	def get_id
		"#{:id}"
	end
	
	def get_id_from_name_building_room
		Student.where("first_name LIKE :first_name AND last_name LIKE :last_name AND building_id <= :building_id AND room_number",
			{:start_date => params[:start_date], :end_date => params[:end_date]})
	end
	

end

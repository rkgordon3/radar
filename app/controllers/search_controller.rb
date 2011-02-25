class SearchController < ApplicationController
  
  autocomplete :student, :first_name, :display_value => :full_name, :full => true
  
  @student_list = Array.new
  
  def search
  end
  
  def get_autocomplete_items(parameters)
    Student.where("first_name LIKE ? OR last_name LIKE ?", "#{parameters[:term]}%").order(:first_name).order(:last_name)
  end
  
  def add_student_to_list(participant)
  	  if @student_list == nil
  	  	  @student_list = Array.new
  	  end
  	  @student_list << participant
  end
  
  def update_list
  	message= params[:first_name]
	split_up = message.split(/, /)
	
	long_name = split_up[0]
	#print long_name
	s_building_id = split_up[1]
	#print s_building_id
	s_room_number = split_up[2]
	#print s_room_number
	
	s_long_name = long_name.split(' ')
	#print s_long_name
	s_first_name = s_long_name[0]
	#print s_first_name
	s_last_name = s_long_name[1]
	#print s_last_name
	

	split_up[3]
		
	
	#@student = Student.where("'first_name' LIKE ? AND 'last_name' LIKE ? AND 'building_id' <= ? AND 'room_number' <= ?",
	#	s_first_name, s_last_name, s_building_id, s_room_number ).first
	@student = Student.find(Integer(split_up[3]))
	
	
	@reported_infractions = session[:incident_report].reported_infractions
	
	exists = false
	
	@reported_infractions.each do |ri|
		if ri.participant_id == @student.id
			exists = true
		end
	end
	
	if exists == false
		newRI = ReportedInfraction.new
		newRI.participant_id = @student.id
		newRI.infraction_id = 22 #fyi
		@reported_infractions << newRI
	end
	
	@message = ''
	
	@reported_infractions.each do |ri|
		@message = @message + '<p>' + ri.participant.first_name + ' ' + ri.participant.last_name + '</p>'
	end
	
	
	render :update do|page|
		page.replace_html 'found', @message
	end
   end

end

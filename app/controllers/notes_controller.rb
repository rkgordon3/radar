class NotesController < ReportsController
  load_and_authorize_resource
  
	def new
    #TODO: should be done by reports_controller and rendered by reports views
		@report = Note.new(:staff_id => current_staff.id)
    @report.process_participant_params_string_from_student_search(params[:participants])
    super
	end
end

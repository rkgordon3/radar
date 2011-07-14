class NotesController < ReportsController
  load_and_authorize_resource
  
	def new
		@report = Note.new(:staff_id => current_staff.id)
                @report.process_participant_params_string_from_student_search(params[:participants])
                 session[:report] = @report
		 respond_to do |format|
		 	 format.html # new.html.erb
		 	 format.xml  { render :xml => @report }
		 	 format.iphone {render :layout => 'mobile_application'}
		 end
	end
end

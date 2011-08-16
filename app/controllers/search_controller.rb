class SearchController < ApplicationController
	before_filter :authenticate_staff!
	
  # autocomplete looks at the student table in the full name field, returns all values that match

  autocomplete :student, :full_name, :display_value => :full_name, :full => true
  
 
  def init_students_from_session
  	 	 @students = session[:students] 
  end	 
  
  def reset_students_in_session	  
  				@students = Hash.new
  				session[:students] = @students   
  end	
  
 def destroy
  	init_students_from_session	 
  	@students.delete(params[:id]) 	  
    respond_to do |format|
    	    format.js
    end 
 end
 
 def update_result_list
 		  logger.debug("IN UPDATE")
 			init_students_from_session
      @student = Participant.get_participant_for_full_name(params[:full_name])

      if !@students.key?(@student.id.to_s) 
	  	  @students[@student.id.to_s] = @student
      end
       respond_to do |format|
   	   format.js
   end 
 end
  
 def index
  	  
   reset_students_in_session

   respond_to do |format|
   	   format.js
   	   format.html 
   end   
end
  def report_search
  	    respond_to  do |format|
    	    format.html # index.html.erb
    	    format.iphone {render :layout => 'mobile_application'}
    end
  end
 

end

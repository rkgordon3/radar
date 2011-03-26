class SearchController < ApplicationController
	before_filter :general_authorize
  # autocomplete looks at the student table in the full name field, returns all values that match
  autocomplete :student, :full_name, :display_value => :full_name, :full => true
  
 
  def init_students_from_session
  	 	 @students = session[:students]
  	 	 logger.debug "student session list #{@students}"
  	 	 logger.debug "+++students type #{@students.class.name}"
  
  end	 
  
  def reset_students_in_session	  
  				@students = Hash.new

  				session[:students] = @students   
  end	
  
 def destroy
  	#init_students_in_session	 
  	@students.delete(params[:id]) 	  
    respond_to do |format|
    	    format.js
    end 
 end
  
 def index
  	  
    #returns student that was selected from autocomplete
    if (params[:full_name] == nil) 
    	reset_students_in_session
    else
    	init_students_from_session
      @student = Student.get_student_object_for_string(params[:full_name])

      if !@students.key?(@student.id.to_s) 
	  	  @students[@student.id.to_s] = @student
      end
    end

   respond_to do |format|
   	   format.js
   	   format.html 
   end   
  end

end

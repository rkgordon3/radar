class SearchController < ApplicationController
  before_filter :general_authorize  
  # autocomplete looks at the student table in the full name field, returns all values that match
  autocomplete :student, :full_name, :display_value => :full_name, :full => true
  
 
  
  def go_to_student
	#returns student that was selected from autocomplete
    @student = Student.get_student_object_for_string(params[:full_name])
    
	#redirects to the students page
    respond_to do |format|
      format.html { redirect_to "/students/" + @student.id.to_s }
      format.xml  { render :xml => @student}
      
    end
    
  end
  
  
  
  def delete_student
  #take the params[:id] to get the index to delete the student out of the session and replace the message
    #if there are no students currently in the session
    if session[:students] == nil
	  # create new array
      session[:students] = Array.new
    end
	
	#assigns all students in the session(0..n) to @students
    @students = session[:students]
	student_to_delete = nil
	@students.each do |s|
	  #check each student's id in the array agains the student to delete
      if params[s.id.to_s] != nil
		student_to_delete = s
		logger.debug "The object is #{s.first_name}"
		end
    end
	
	if student_to_delete != nil
		
		@students.delete(student_to_delete)
	end
	#initialize message
    
    
	@message = self.message(@students)
	
    
	#replace 'found' (in report_search) with the new message
    render :update do |page|
      page.replace_html 'found', @message
    end
  
  end
  
  
  def message(students)
	@message = ''
    students.each do |s|
	  #message will be all students first and last names
      #@message = @message + '<p>' + '<input type="submit" value="X" name="' + s.id.to_s + '"> </input>' + s.first_name + ' ' + s.last_name + '</p>'
	  @message = @message + '<p>' + '<input id="' + s.id.to_s + '" name="' + s.id.to_s + '" type="submit" value="X" />' + s.first_name + ' ' + s.last_name + '</p>'
	  end
	return @message
  end
  
  
  
  def update_list
    #returns student that was selected from autocomplete
    @student = Student.get_student_object_for_string(params[:full_name])
    
	#if there are no students currently in the session
    if session[:students] == nil
	  # create new array
      session[:students] = Array.new
    end
	
	#assigns all students in the session(0..n) to @students
    @students = session[:students]
    
	#check to make sure a student doesn't already exist in the array of students in the session
    exists = false
	#for each student
    @students.each do |s|
	  #check each student's id in the array agains the student to add
      if s.id == @student.id
        exists = true
      end
    end
    
	#if the student was not found in the students in the session
    if exists == false
	  #add the student selected to the students in the session
      @students << @student
    end
    
	#initialize message
    @message = self.message(@students)
    
	#replace 'found' (in report_search) with the new message
    render :update do |page|
      page.replace_html 'found', @message
    end
    
  end

end

class SearchController < ApplicationController
  before_filter :general_authorize  
  autocomplete :student, :full_name, :display_value => :full_name, :full => true
  
  def search
  end
  
  def get_autocomplete_items(parameters)
    Student.where("first_name LIKE ? OR last_name LIKE ?", "#{parameters[:term]}%").order(:first_name).order(:last_name)
  end
  
  
  def go_to_student
    @student = Student.get_student_object_for_string(params[:full_name])
    
    
    respond_to do |format|
      format.html { redirect_to "/students/" + @student.id.to_s }
      format.xml  { render :xml => @student}
      
    end
    
  end
  
  
  def update_list
    
    @student = Student.get_student_object_for_string(params[:full_name])
    
    if session[:students] == nil
      session[:students] = Array.new
    end
    @students = session[:students]
    
    exists = false
    @students.each do |s|
      if s.id == @student.id
        exists = true
      end
    end
    
    if exists == false
      @students << @student
    end
    
    @message = ''
    
    @students.each do |s|
      @message = @message + '<p>' + s.first_name + ' ' + s.last_name + '</p>'
    end
    
    
    render :update do|page|
    page.replace_html 'found', @message
  end
end

end

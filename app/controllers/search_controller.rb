class SearchController < ApplicationController
  autocomplete :student, :first_name, :display_value => :full_name
  
  @student_list = Array.new
  
  def search
  end
  
  
  
  def add_student_to_list(participant)
  	  if @student_list == nil
  	  	  @student_list = Array.new
  	  end
  	  @student_list << participant
  end

end

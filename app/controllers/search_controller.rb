class SearchController < ApplicationController
  before_filter :authorize, :except => :index
  autocomplete :student, :first_name, :display_value => :full_name
  
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

end

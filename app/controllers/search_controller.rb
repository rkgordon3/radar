class SearchController < ApplicationController

  autocomplete :student, :first_name, :display_value => :full_name, :full => true
  def search
  end
  
  def get_autocomplete_items(parameters)
    Student.where("first_name LIKE ? OR last_name LIKE ?", "#{parameters[:term]}%").order(:first_name).order(:last_name)
  end

end

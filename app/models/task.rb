class Task < ActiveRecord::Base
  
  def Task.get_by_constraints(area_id, datetime)
    return Task.where("(area_id IS NULL OR area_id = ?) AND (start_date < ? OR start_date IS NULL) AND (end_date > ? OR end_date IS NULL)", area_id, datetime, datetime)
  end
  
end

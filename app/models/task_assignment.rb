class TaskAssignment < ActiveRecord::Base
  belongs_to :shift
  belongs_to :task
  
  def done_string
    if self.done
      return "yes"
    else
      return "no"
    end
  end
  
  def done_time
    if self.done
      return "" + self.updated_at.to_s(:time_only) + ", " + self.updated_at.to_s(:short_date_only)
    else
      return ""
    end
  end
  
end

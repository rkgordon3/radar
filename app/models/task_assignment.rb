class TaskAssignment < ActiveRecord::Base
  belongs_to :shift
  belongs_to :task

  def TaskAssignment.sort(data, key)
    if key=="title"
      return data.joins(:task).order("title ASC").all
    elsif key=="due_time"
      return data.joins(:task).order("date(task_assignments.created_at) DESC, tasks.time ASC").all
    elsif key=="done_time"
      return data.where(:done => true).order("updated_at DESC").all + data.where(:done => false).all
    elsif key=="staff"
      return data.joins(:shift=>:staff).order("last_name ASC").all
    else
      return data.joins(:task).order("date(task_assignments.created_at) DESC, tasks.time ASC").all
    end
  end
  
  def done_string
    if self.done
      return "yes"
    end
      return "no"
  end
  
  def done_time
    if self.done
      return "" + self.updated_at.to_s(:time_only) + ", " + self.updated_at.to_s(:short_date_only)
    end
      return "not done"
  end

  def due_time
    return "" + self.task.time_string + ", " + self.created_at.to_s(:short_date_only)
  end
  
end

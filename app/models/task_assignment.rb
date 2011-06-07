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
  
end

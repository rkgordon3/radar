class TaskAssignment < ActiveRecord::Base
  belongs_to :shift
  belongs_to :task
  
end

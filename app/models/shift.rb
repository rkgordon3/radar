class Shift < ActiveRecord::Base
  belongs_to :staff
  has_many :rounds
  belongs_to :area
  has_many :task_assignments
  
  def add_task (task)
    ta = TaskAssignment.new(:shift_id => self.id, :task_id => task.id, :done => false)
    self.task_assignments << ta
  end
  
  def save
    self.task_assignments.each do |ta|
      ta.save
    end
    super
  end
  
  def tasks_completed? 
  logger.debug("TASKS COMPLETED? #{ TaskAssignment.where(:shift_id => self.id, :done => false).length}")
   TaskAssignment.where(:shift_id => self.id, :done => false).length == 0
  end
 
  
  def start_time
    created_at.to_s(:time_only)
  end
  
  def start_date
    created_at.to_s(:short_date_only)
  end
  
  def end_time
    time_out.to_s(:time_only)
  end
  
  def end_date
    time_out.to_s(:short_date_only)
  end
  
  def Shift.sort(data,key)
    new_data = data.order("created_at DESC")
    if key=="time_in"
      #default already sorted by start date
    elsif key=="time_out"
      new_data = data.order("time_out DESC")
    elsif key=="area"
      new_data=data.joins(:area).order("name ASC")
    elsif key=="submitter"
      new_data=data.joins(:staff).order("last_name ASC")
    end
    return new_data
  end
  
end

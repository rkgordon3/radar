class Task < ActiveRecord::Base
  belongs_to :area
  scope :active, where("start_date <= ? AND (end_date >= ? OR expires = ?)", Time.now.at_beginning_of_day , Time.now.at_beginning_of_day, false )
  scope :scheduled, where("start_date > ? AND (end_date > start_date OR expires = ?)", Time.now.at_beginning_of_day, false )
  scope :expired, where("(start_date > end_date OR end_date < ?) AND expires = ?", Time.now.at_beginning_of_day, true )
  ANYTIME = -1
  
  def Task.sort(key)
    if key=="title"
      return Task.order("title ASC").all
    elsif key=="note"
      return Task.order("note ASC").all
    elsif key=="start_date"
      return Task.order("start_date ASC, expires DESC, end_date ASC").all
    elsif key=="end_date"
      return Task.order("expires DESC, end_date ASC").all
    elsif key=="area"
      return Task.joins(:area).order("name ASC").all
    end
    return Task.active.order("expires DESC, end_date ASC").all + Task.scheduled.order("start_date ASC, expires DESC, end_date ASC").all + Task.expired.order("expires DESC, end_date ASC").all
  end
  
  def Task.get_active_by_area(area_id)
    return Task.active.where("area_id = ? OR area_id = ?", 1, area_id)
  end
  
  #this method 
  def time_string
    if self.time == ANYTIME
      return "@anytime"
    end
    t=Time.new(0).advance({:minutes=>self.time})
    return "@" + t.to_s(:time_only)
  end

  def title_time_string
    return self.time_string + ", " + self.title
  end
  
  def info
    if self.note != nil
      if self.note.length != 0
        if self.time != ANYTIME
          return "" + self.time_string + ", " + self.note
        end
        return self.note
      end
    end
    if self.time > ANYTIME
      return self.time_string
    end
    return ""
  end
  
  def status
    if Task.active.exists?(self.id)
      return "Active"
    elsif Task.scheduled.exists?(self.id)
      return "Scheduled"
    else
      return "Expired"
    end
    
  end

  def start_date_only
    self.start_date.to_s(:date_only)
  end

  def end_date_only
    self.end_date.to_s(:date_only)
  end
  
  def date_range
    return start_date_short + " - " + end_date_short
  end
  
  def start_date_short
    self.start_date.to_s(:short_date_only)
  end
  
  def end_date_short
    if self.expires
      return self.end_date.to_s(:short_date_only)
    end
    return "does not expire"
  end
  
  def update_attributes(task)
    if !super(task)
      return false
    end
    self.start_date = self.start_date.advance({:hours=>0})
    self.end_date = self.end_date.advance({:hours=>0})
    self.save
    return true
  end
  
end

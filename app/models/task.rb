class Task < ActiveRecord::Base
  belongs_to :area
  scope :active, where("start_date <= ? AND (end_date >= ? OR expires = ?)", MyTime.now, MyTime.now, false )
  scope :scheduled, where("start_date > ? AND (end_date > start_date OR expires = ?)", MyTime.now, false )
  scope :expired, where("(start_date > end_date OR end_date < ?) AND expires = ?", MyTime.now, true )
  
  
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
  
  def expires_string
    if self.expires
      return "yes"
    else
      return "no"
    end
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
  
  def date_range
    range = self.start_date.to_s(:short_date_only)
    if self.expires
      return range + " - " + self.end_date.to_s(:short_date_only)
    end
    return range + " - (does not expire)"
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
  
end

class Task < ActiveRecord::Base
  belongs_to :area
  
  def Task.sort(data,key)
    if key=="title"
      return data.order("title ASC")
    elsif key=="note"
      return data.order("note ASC")
    elsif key=="start_date"
      return data.order("start_date ASC, expires DESC, end_date ASC")
    elsif key=="end_date"
      return data.order("expires DESC, end_date ASC")
    end
    return data.joins(:area).order("name ASC")
  end
  
  def Task.get_active_by_area(area_id)
    return Task.where("(area_id = ? OR area_id = ?) AND start_date < ? AND (end_date > ? OR expires = ?)", 1, area_id, Time.now, Time.now, false)
  end
  
  def Task.get_expired
    return Task.where("end_date < ? AND expires = ?)", Time.now, true)
  end
  
  def Task.get_active
    return Task.where("start_date < ? AND (end_date > ? OR expires = ?)", Time.now, Time.now, false)
  end
  
  def Task.get_future
    return Task.where("start_date > ? AND (end_date > ? OR expires = ?)", Time.now, Time.now, false)
  end
  
  def expires_string
    if self.expires
      return "yes"
    else
      return "no"
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

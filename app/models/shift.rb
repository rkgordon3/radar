class Shift < ActiveRecord::Base
  belongs_to  	:staff
  has_many :rounds
  belongs_to :area
  
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
  
  def time
    
    if start_date == end_date
      "" + start_time + " - " + end_time
    else
      "" + start_time + " - " + end_time + ", " + end_date
    end
  end
  
end

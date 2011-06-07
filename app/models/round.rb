class Round < ActiveRecord::Base
belongs_to  	:shift

def start_time
    created_at.to_s(:time_only)
  end
  
  def start_date
    created_at.to_s(:short_date_only)
  end
  
  def end_time_only
    end_time.to_s(:time_only)
  end
  
  def end_date
    end_time.to_s(:short_date_only)
  end

end

class Shift < ActiveRecord::Base
belongs_to  	:staff

def on_off_duty
logger.debug "HEREEEEE"
self.staff_id = 3
end  
  
end

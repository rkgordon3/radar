class Building < ActiveRecord::Base
  
  def Building.unspecified
    return 1
  end
  
  def Building.end_of_res_hall_id
    return 16
  end
  
end

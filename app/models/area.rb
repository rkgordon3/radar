class Area < ActiveRecord::Base
	has_many :buildings
  
  def Area.unspecified
    return 1
  end
  
end

class Area < ActiveRecord::Base
	has_many :buildings
  
  def Area.unspecified
    return 1
  end
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name,:abbreviation
  
end

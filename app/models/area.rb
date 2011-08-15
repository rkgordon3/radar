class Area < ActiveRecord::Base
	has_many :buildings
  
  def Area.unspecified
    Area.find_by_name("Unspecified").id rescue 0
  end
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name,:abbreviation
  
end

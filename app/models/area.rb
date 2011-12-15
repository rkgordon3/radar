class Area < ActiveRecord::Base
	has_many :buildings
	has_many :staff_areas
  
  def Area.unspecified_id
    Area.find_by_name(unspecified).id rescue 0
  end

  def destroy
    buildings = Building.where(:area_id => self.id)
    buildings.each do |b|
      b.area_id = Area.unspecified_id
      b.save
    end
    super
  end
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name,:abbreviation
  
end

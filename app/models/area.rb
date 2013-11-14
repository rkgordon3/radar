class Area < ActiveRecord::Base
	has_many :buildings
	has_many :staff_areas
	
  def Area.unspecified
    @@unspecified ||= Area.find_by_name(UNSPECIFIED_AREA)
  end
  
  def Area.unspecified_id
    Area.unspecified.id rescue 0
  end

  def Area.sort(key)
    a = Area.where("id <> ?", Area.unspecified.id)
    if key=="name"
      return a.order("name ASC").all
    elsif key=="abbreviation"
      return a.order("abbreviation ASC").all
    elsif key=="buildings"
      return a.order("name ASC").all
    else
      return a.order("name ASC").all
    end
  end

  def destroy
    buildings = Building.where(:area_id => self.id)
    buildings.each do |b|
      b.area_id = Area.unspecified_id
      b.save
    end
    super
  end

  def update_attributes(params)
    buildings = Building.where(:area_id => self.id)
    buildings.each do |b|
      b.area_id = Area.unspecified_id
      b.save
    end
    self.buildings = Building.find(params[:buildings]) if params[:buildings] != nil
    super(params)
  end
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name,:abbreviation,:buildings

  def <=> other
    return  1 if other == Area.unspecified
    return -1 if self == Area.unspecified
    return self.name <=> other.name  
  end
  
end
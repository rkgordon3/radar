class Building < ActiveRecord::Base
  belongs_to :area
  
  def Building.unspecified_id
    @@unspecified_id ||= Building.find_by_name(UNSPECIFIED_BUILDING).id rescue 0
  end
  
  def Building.unspecified
    @@unspecified ||= Building.find_by_name(UNSPECIFIED_BUILDING)
  end

  def Building.sort(key)
    if key=="name"
      return Building.order("name ASC").all
    elsif key=="abbreviation"
      return Building.order("abbreviation ASC").all
    elsif key=="residence"
      return Building.order("is_residence DESC").all
    elsif key=="area"
      return Building.joins(:area).order("areas.name").all
    else
      return Building.order("name ASC").all
    end
  end
  
  def <=> other
	return  1 if other == Building.unspecified
	return -1 if self == Building.unspecified
	return self.name <=> other.name  
  end

end

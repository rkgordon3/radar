class Building < ActiveRecord::Base
  belongs_to :area
  
  def Building.unspecified_id
    Building.find_by_name(unspecified).id rescue 0
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

end

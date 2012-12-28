module BuildingsHelper
  def BuildingsHelper.residence_halls
    @@res_halls ||= Building.where("is_residence = 1 or name like '%Off Campus%'").select{ |b| b != Building.unspecified}.sort
  end
  
  def BuildingsHelper.all_buildings
    @@all_buildings  ||= Building.all.select { |b| b != Building.unspecified}.sort
  end
  
  def building_div_id(building)
    "building_#{building.id}_div".html_safe
  end
end

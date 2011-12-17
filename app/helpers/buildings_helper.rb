module BuildingsHelper
  def BuildingsHelper.residence_halls
    # The remove of Building.unspecified from results is kludge until we remove it from table
    @@res_halls ||= Building.where("is_residence = 1 or name like '%Off Campus%'").select{ |b| b != Building.unspecified}.sort
  end
  
  def BuildingsHelper.all_buildings
  # The remove of Building.unspecified from results is kludge until we remove it from table
    @@all_buildings  ||= Building.all.select { |b| b != Building.unspecified}.sort
  end
end

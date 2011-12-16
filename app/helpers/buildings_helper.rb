module BuildingsHelper
  def BuildingsHelper.residence_halls
    @@res_halls ||= Building.where("is_residence = 1 or name like '%Off Campus%'").sort
  end
end

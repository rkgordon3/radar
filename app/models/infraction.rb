class Infraction < ActiveRecord::Base
  
  def Infraction.fyi
    fyi_id = Infraction.where(:description => "FYI")
    return fyi_id.first.id
  end
  
end

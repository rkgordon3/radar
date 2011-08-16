class Building < ActiveRecord::Base
  belongs_to :area
  
  def Building.unspecified_id
    Building.find_by_name(unspecified).id rescue 0
  end

end

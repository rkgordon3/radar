class Building < ActiveRecord::Base
  belongs_to :area
  
  def self.unspecified
    Building.find_by_name("Unspecified").id rescue 0
  end

end

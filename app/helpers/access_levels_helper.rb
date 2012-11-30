module AccessLevelsHelper


  def self.assignable_by(ability)   
    AccessLevel.accessible_by(ability, :assign).select { |a| a.name != "root" }.sort
  end
end

module AccessLevelsHelper


  def self.assignable_by(ability)
    AccessLevel.accessible_by(ability, :assign).collect.sort  
  end
end

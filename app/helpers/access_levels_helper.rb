module AccessLevelsHelper


  def self.assignable_for(ability)   
    @@types ||= AccessLevel.accessible_by(ability, :assign).collect.sort
  end
end

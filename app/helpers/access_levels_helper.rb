module AccessLevelsHelper


  def self.assignable_by(ability)   
	AccessLevel.all.sort
  end
end

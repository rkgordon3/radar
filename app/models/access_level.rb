class AccessLevel < ActiveRecord::Base

# FIXME This should not be here.
	
  def log_type
    if self.name == "ResidentAssistant" || self.name == "Staff"
      return "duty"
    elsif self.name == "HallDirector" || self.name == "Supervisor"
      return "call"
    end
    return "no"
  end
  
  def save
    self.display_name = self.name.underscore.titleize if self.display_name.nil?
	super
  end
  
  def <=> other
	self.display_name <=> other.display_name
  end

end

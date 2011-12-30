class AccessLevel < ActiveRecord::Base

  def log_type
    if self.name == "ResidentAssistant"
      return "duty"
    elsif self.name == "HallDirector"
      return "call"
    end
    return "no"
  end
  
  def save
    self.display_name = self.name.underscore.titleize if self.display_name.nil?
	super
  end

end

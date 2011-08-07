class AccessLevel < ActiveRecord::Base

  def log_type
    if self.name == "ResidentAssistant"
      return "Duty"
    elsif self.name == "HallDirector"
      return "Call"
    end
    return "No"
  end

end

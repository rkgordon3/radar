class AccessLevel < ActiveRecord::Base

  def log_type
    if self.name == "ResidentAssistant"
      return "duty"
    elsif self.name == "HallDirector"
      return "call"
    end
    return "no"
  end

end

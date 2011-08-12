class AccessLevel < ActiveRecord::Base

  def AccessLevel.numeric_level(symbol)
    if symbol == :resident_assistant
      return 1
    elsif symbol == :hall_director
      return 2
    elsif symbol == :administrative_assistant
      return 3
    elsif symbol == :administrator
      return 4
    elsif symbol == :system_administrator
      return 5
    end
  end

  def log_type
    if self.name == "ResidentAssistant"
      return "duty"
    elsif self.name == "HallDirector"
      return "call"
    end
    return "no"
  end

end

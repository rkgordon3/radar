class MyTime < Time
  # returns an instance of Time.now rounded to the current day
  def MyTime.now
    return Time.new(Time.now.year,Time.now.month,Time.now.day)
  end
end
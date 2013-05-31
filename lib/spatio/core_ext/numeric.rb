class Numeric
  def duration
    secs  = self.to_int
    mins  = secs / 60
    hours = mins / 60

    if hours > 0
      "#{hours} hours and #{mins % 60} minutes"
    elsif mins > 0
      "#{mins} minutes and #{secs % 60} seconds"
    elsif secs >= 0
      "#{secs} seconds"
    end
  end
end

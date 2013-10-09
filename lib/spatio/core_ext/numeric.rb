class Numeric
  # Returns the duration in words:
  # - In hours and minutes if > 1 hour
  # - In minutes and seconds if > 1 minute
  # - In seconds otherwise
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

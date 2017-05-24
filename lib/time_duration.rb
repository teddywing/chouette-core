module TimeDuration
  # `earlier` and `later` are times. Get the duration between those times and
  # check whether it's longer than the given `duration`.
  #
  # Example:
  #   TimeDuration.exceeds_gap?(
  #     4.hours,
  #     Time.now,
  #     Time.now + 2.hours
  #   )
  def self.exceeds_gap?(duration, earlier, later)
    duration < (later - earlier)
  end
end

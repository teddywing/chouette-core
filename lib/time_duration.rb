module TimeDuration
  def self.exceeds_gap?(duration, earlier, later)
    duration < (later - earlier)
  end
end

module TimeDuration
  def self.exceeds_gap?(duration, earlier, later)
    (4 * 3600) < ((later - earlier) % (3600 * 24))
  end
end

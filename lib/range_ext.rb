class Range
  def intersection(other)
    return nil if (self.max < other.min or other.max < self.min)
    [self.min, other.min].max..[self.max, other.max].min
  end
  alias_method :&, :intersection
end

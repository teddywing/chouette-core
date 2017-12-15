require 'range_ext'
require_relative 'calendar/date_value'
require_relative 'calendar/period'

class BusinessCalendar < ActiveRecord::Base
  include CalendarSupport
  extend Enumerize
  enumerize :color, in: %w(#9B9B9B #FFA070 #C67300 #7F551B #41CCE3 #09B09C #3655D7 #6321A0 #E796C6 #DD2DAA)

  scope :overlapping, -> (period_range) do
    where("(periods.begin <= :end AND periods.end >= :begin) OR (dates BETWEEN :begin AND :end)", {begin: period_range.begin, end: period_range.end})
  end

  def bounding_dates
    bounding_min = self.dates.min
    bounding_max = self.dates.max

    unless self.periods.empty?
      bounding_min = periods_min_date if periods_min_date && (bounding_min.nil? || (periods_min_date < bounding_min))

      bounding_max = periods_max_date if periods_max_date && (bounding_max.nil? || (bounding_max < periods_max_date))
    end

    [bounding_min, bounding_max].compact
  end

  def periods_max_date
    return nil if self.periods.empty?
    self.periods.max.end
  end

  def periods_min_date
    return nil if self.periods.empty?
    self.periods.min.begin
  end

end
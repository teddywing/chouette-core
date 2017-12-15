require 'range_ext'
require_relative 'calendar/date_value'
require_relative 'calendar/period'

class BusinessCalendar < ActiveRecord::Base
  include CalendarSupport
  extend Enumerize
  enumerize :color, in: %w(#9B9B9B #FFA070 #C67300 #7F551B #41CCE3 #09B09C #3655D7 #6321A0 #E796C6 #DD2DAA)

  scope :contains_date, ->(date) { where('date ? = any (dates) OR date ? <@ any (date_ranges)', date, date) }

  def self.ransackable_scopes(auth_object = nil)
    [:contains_date]
  end

end

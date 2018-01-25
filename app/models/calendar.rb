require 'range_ext'
require_relative 'calendar/date_value'
require_relative 'calendar/period'

class Calendar < ActiveRecord::Base
  include DateSupport
  include PeriodSupport

  has_paper_trail class_name: 'PublicVersion'
  belongs_to :organisation
  belongs_to :workgroup

  validates_presence_of :name, :short_name, :organisation, :workgroup
  validates_uniqueness_of :short_name

  has_many :time_tables

  scope :contains_date, ->(date) { where('date ? = any (dates) OR date ? <@ any (date_ranges)', date, date) }

  def self.ransackable_scopes(auth_object = nil)
    [:contains_date]
  end

  def convert_to_time_table
    Chouette::TimeTable.new.tap do |tt|
      self.dates.each do |d|
        tt.dates << Chouette::TimeTableDate.new(date: d, in_out: true)
      end
      self.periods.each do |p|
        tt.periods << Chouette::TimeTablePeriod.new(period_start: p.begin, period_end: p.end)
      end
      tt.int_day_types = 508
    end
  end

end

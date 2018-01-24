module ApplicationDaysSupport
  extend ActiveSupport::Concern

  included do |into|
    into.class_eval do
      MONDAY    = 4
      TUESDAY   = 8
      WEDNESDAY = 16
      THURSDAY  = 32
      FRIDAY    = 64
      SATURDAY  = 128
      SUNDAY    = 256
    end

    # attr_accessor :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  end

  def display_day_types
    %w(monday tuesday wednesday thursday friday saturday sunday).select{ |d| self.send(d) }.map{ |d| self.human_attribute_name(d).first(2)}.join(', ')
  end

  def day_by_mask(flag)
    int_day_types & flag == flag
  end

  def self.day_by_mask(int_day_types,flag)
    int_day_types & flag == flag
  end

  def valid_days
    # Build an array with day of calendar week (1-7, Monday is 1).
    [].tap do |valid_days|
      valid_days << 1  if monday
      valid_days << 2  if tuesday
      valid_days << 3  if wednesday
      valid_days << 4  if thursday
      valid_days << 5  if friday
      valid_days << 6  if saturday
      valid_days << 7  if sunday
    end
  end

  def self.valid_days(int_day_types)
    # Build an array with day of calendar week (1-7, Monday is 1).
    [].tap do |valid_days|
      valid_days << 1  if day_by_mask(int_day_types,MONDAY)
      valid_days << 2  if day_by_mask(int_day_types,TUESDAY)
      valid_days << 3  if day_by_mask(int_day_types,WEDNESDAY)
      valid_days << 4  if day_by_mask(int_day_types,THURSDAY)
      valid_days << 5  if day_by_mask(int_day_types,FRIDAY)
      valid_days << 6  if day_by_mask(int_day_types,SATURDAY)
      valid_days << 7  if day_by_mask(int_day_types,SUNDAY)
    end
  end

  def monday
    day_by_mask(MONDAY)
  end
  def tuesday
    day_by_mask(TUESDAY)
  end
  def wednesday
    day_by_mask(WEDNESDAY)
  end
  def thursday
    day_by_mask(THURSDAY)
  end
  def friday
    day_by_mask(FRIDAY)
  end
  def saturday
    day_by_mask(SATURDAY)
  end
  def sunday
    day_by_mask(SUNDAY)
  end

  def set_day(day,flag)
    if day == '1' || day == true
      self.int_day_types |= flag
    else
      self.int_day_types &= ~flag
    end
    shortcuts_update
  end

  def monday=(day)
    set_day(day,4)
  end
  def tuesday=(day)
    set_day(day,8)
  end
  def wednesday=(day)
    set_day(day,16)
  end
  def thursday=(day)
    set_day(day,32)
  end
  def friday=(day)
    set_day(day,64)
  end
  def saturday=(day)
    set_day(day,128)
  end
  def sunday=(day)
    set_day(day,256)
  end
end

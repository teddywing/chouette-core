class CalendarObserver < ActiveRecord::Observer

  def after_update calendar
    return unless calendar.shared

    User.with_organisation.each do |user|
      MailerJob.perform_later('CalendarMailer', 'updated', [calendar, user])
    end
  end

  def after_create calendar
    return unless calendar.shared

    User.with_organisation.each do |user|
      MailerJob.perform_later('CalendarMailer', 'created', [calendar, user])
    end
  end
end

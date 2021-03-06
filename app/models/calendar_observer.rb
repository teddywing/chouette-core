class CalendarObserver < ActiveRecord::Observer

  def after_update calendar
    return unless calendar.shared

    User.from_workgroup(calendar.workgroup_id).each do |user|
      MailerJob.perform_later('CalendarMailer', 'updated', [calendar.id, user.id])
    end
  end

  def after_create calendar
    return unless calendar.shared

    User.from_workgroup(calendar.workgroup_id).each do |user|
      MailerJob.perform_later('CalendarMailer', 'created', [calendar.id, user.id])
    end
  end
end

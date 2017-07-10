# Preview all emails at http://localhost:3000/rails/mailers/calendar_mailer
class CalendarMailerPreview < ActionMailer::Preview

  def created
    cal = Calendar.new(name: 'test calendar', shared: true)
    CalendarMailer.created(cal, User.take)
  end

  def updated
    cal = Calendar.new(name: 'test calendar', shared: true)
    CalendarMailer.updated(cal, User.take)
  end
end

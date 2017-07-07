class CalendarMailer < ApplicationMailer
  def updated calendar
    users = User.all
    users.each do |u|
      mail to: u.email, subject: t('mailers.calendar_mailer.updated.subject')
    end
  end

  def created calendar
    users = User.all
    users.each do |u|
      mail to: u.email, subject: t('mailers.calendar_mailer.created.subject')
    end
  end
end

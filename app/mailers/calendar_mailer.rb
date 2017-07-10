class CalendarMailer < ApplicationMailer
  def updated calendar, user
    @calendar = calendar
    mail to: user.email, subject: t('mailers.calendar_mailer.updated.subject')
  end

  def created calendar, user
    @calendar = calendar
    mail to: user.email, subject: t('mailers.calendar_mailer.created.subject')
  end
end

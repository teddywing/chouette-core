class MailerJob < ActiveJob::Base
  queue_as :mail

  def perform klass, action, params
    klass.constantize.public_send(action, *params).deliver
  end
end

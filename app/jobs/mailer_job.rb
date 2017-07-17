class MailerJob < ActiveJob::Base
  # No need to specify queue it's already used mailers queue

  def perform klass, action, params
    klass.constantize.public_send(action, *params).deliver_later
  end
end

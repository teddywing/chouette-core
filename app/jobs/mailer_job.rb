class MailerJob < ActiveJob::Base
  # No need to specify queue it's already used mailers queue

  # This job will be retried, unlike Sidekiq jobs which are configured
  # to not retry

  def perform klass, action, params
    klass.constantize.public_send(action, *params).deliver_later
  end
end

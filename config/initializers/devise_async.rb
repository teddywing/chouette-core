Devise::Async.backend = :sidekiq
Devise::Async.enabled = false # Set to true to use Delayed Job for asynchronous mail

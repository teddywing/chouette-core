class CleanUpWorker
  include Sidekiq::Worker

  def perform(id)
    cleaner = CleanUp.find id
    cleaner.run!
    begin
      cleaner.referential.switch
      result = cleaner.clean
      cleaner.successful!
    rescue Exception => e
      Rails.logger.error "CleanUpWorker : #{e}"
      cleaner.failed!
    end
  end
end

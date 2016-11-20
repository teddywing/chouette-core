class CleanUpWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(id)
    cleaner = CleanUp.find id
    cleaner.run if cleaner.may_run?
    begin
      cleaner.referential.switch
      result = cleaner.clean
      cleaner.successful(result)
    rescue Exception => e
      Rails.logger.error "CleanUpWorker : #{e}"
      cleaner.failed({error: e.message})
    end
  end
end

class ComplianceControlSetCloningWorker
  include Sidekiq::Worker

  def perform id
    ComplianceControlSetCloner.new.copy id
  end

end

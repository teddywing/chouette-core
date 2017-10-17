class ComplianceControlSetCloningWorker
  include Sidekiq::Worker

  def perform id, organisation_id
    ComplianceControlSetCloner.new.copy id, organisation_id
  end

end

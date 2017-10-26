class ComplianceControlSetCopyWorker
  include Sidekiq::Worker

  def perform(control_set_id, referential_id)
    ComplianceControlSetCopier.new.copy(control_set_id, referential_id)
  end
end

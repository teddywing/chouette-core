class ComplianceControlSetCopyWorker
  include Sidekiq::Worker

  def perform(cc_set_id, referential_id)
    ComplianceControlSetCopier.new.copy(cc_set_id, referential_id)
  end

end

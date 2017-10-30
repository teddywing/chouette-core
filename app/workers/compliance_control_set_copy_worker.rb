class ComplianceControlSetCopyWorker
  include Sidekiq::Worker

  def perform(control_set_id, referential_id)
    ComplianceControlSetCopier.new.copy(control_set_id, referential_id)

    begin
      Net::HTTP.get(URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/validator/new?id=#{control_set_id}"))
    rescue Exception => e
      logger.error "IEV server error : #{e.message}"
      logger.error e.backtrace.inspect
    end
  end
end

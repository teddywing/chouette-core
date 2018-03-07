require 'net/http'
class Import::Gtfs < Import::Base
  before_destroy :destroy_non_ready_referential

  after_commit :launch_java_import, on: :create
  before_save def abort_unless_referential
    self.status = 'aborted' unless referential
  end

  def launch_java_import
    return if self.class.finished_statuses.include?(status)
    threaded_call_boiv_iev
  end

  private

  def destroy_non_ready_referential
    if referential && !referential.ready
      referential.destroy
    end
  end

  def threaded_call_boiv_iev
    Thread.new(&method(:call_boiv_iev))
  end

  def call_boiv_iev
    Rails.logger.error("Begin IEV call for import")
    Net::HTTP.get(URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/importer/new?id=#{id}"))
    Rails.logger.error("End IEV call for import")
  rescue Exception => e
    logger.error "IEV server error : #{e.message}"
    logger.error e.backtrace.inspect
  end

end

require 'net/http'
class NetexImport < Import
  before_destroy :destroy_non_ready_referential

  after_commit :launch_java_import, on: :create
  before_save def abort_unless_referential
    self.status = 'aborted' unless referential
  end

  validates_presence_of :parent

  def launch_java_import
    return if self.class.finished_statuses.include?(status)
    threaded_call_boiv_iev
  end

  private

  def destroy_non_ready_referential
    unless referential.ready
      referential.destroy
    end
  end

  def threaded_call_boiv_iev
    Thread.new(&method(:call_boiv_iev))
  end

  def call_boiv_iev
    Net::HTTP.get(URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/importer/new?id=#{id}"))
  rescue Exception => e
    logger.error "IEV server error : #{e.message}"
    logger.error e.backtrace.inspect
  end

end

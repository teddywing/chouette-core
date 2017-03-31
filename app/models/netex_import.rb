require 'net/http'
class NetexImport < Import
  after_create :launch_java_import

  def launch_java_import
    logger.warn  "Call iev get #{Rails.configuration.iev_url}/boiv_iev/referentials/importer/new?id=#{id}"
    begin
      Net::HTTP.get(Rails.configuration.iev_url, "/boiv_iev/referentials/importer/new?id=#{id}")
    rescue
      logger.error("IEV server error")
    end
  end
end

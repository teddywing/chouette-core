class WorkbenchImportWorker
  include Sidekiq::Worker
  attr_reader :import, :downloaded

  def perform(import_id)
    @import = Import.find(import_id)
    @downloaded = nil
    download
  end

  def download
    logger.warn  "Call iev get #{Rails.configuration.fe_url}/boiv_iev/referentials/importer/new?id=#{id}"
    begin
      Net::HTTP.get(URI("#{Rails.configuration.front_end_url}/boiv_iev/referentials/importer/new?id=#{id}"))
    rescue Exception => e
      logger.error "IEV server error : e.message"
      logger.error e.backtrace.inspect
    end
    
    
      require 'pry'
      binding.pry
      42

  end

  def import_uri
     @__import_uri__ ||= URI(import_url) 
  end
  def import_url
    @__import_url__ ||= File.join(download_workbench_import_path(import.workbench, import)) 
  end

end

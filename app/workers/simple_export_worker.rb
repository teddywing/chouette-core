class SimpleExportWorker
  include Sidekiq::Worker

  def perform(export_id)
    Export::Base.find(export_id).call_exporter
  end
end

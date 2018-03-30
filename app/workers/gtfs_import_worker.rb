class WorkbenchImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    Import::Gtfs.find(import_id).import
  end
end

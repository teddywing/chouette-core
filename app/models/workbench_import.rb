class WorkbenchImport < Import
  after_commit :launch_worker, :on => :create

  def launch_worker
    WorkbenchImportWorker.perform_async(id)
  end
end

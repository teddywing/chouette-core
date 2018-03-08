class Export::Workbench < Export::Base
  after_commit :launch_worker, :on => :create

  option :timelapse, required: true, type: :integer, default_value: 90

  def launch_worker
    # WorkbenchImportWorker.perform_async(id)
  end
end

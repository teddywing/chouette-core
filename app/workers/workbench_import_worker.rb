class WorkbenchImportWorker
  include Sidekiq::Worker
  attr_reader :import, :downloaded

  def perform(import_id)
    @import = Import.find(import_id)
    @downloaded = nil
    download
  end

  def download
    
    
      require 'pry'
      binding.pry
      42

  end
end

class WorkbenchImportWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  include Configurable

  RETRY_DELAYS = [3, 5, 8]

  # Workers
  # =======

  def perform(import_id)
    @workbench_import = WorkbenchImport.find(import_id)
    @response         = nil
    @workbench_import.update_attributes(status: 'running')
    downloaded  = download
    zip_service = ZipService.new(downloaded)
    upload zip_service
  end

  def download
    logger.info  "HTTP GET #{import_url}"
    @zipfile_data = HTTPService.get_resource(
      host: import_host,
      path: import_path,
      params: {token: @workbench_import.token_download}).body
  end

  def execute_post eg_name, eg_stream
    logger.info  "HTTP POST #{export_url} (for #{complete_entry_group_name(eg_name)})"
    HTTPService.post_resource(
      host: export_host,
      path: export_path,
      token: token(eg_name),
      params: params,
      upload: {file: [eg_stream, 'application/zip', eg_name]})
  end

  def log_failure reason, count
    logger.warn "HTTP POST failed with #{reason}, count = #{count}, response=#{@response}"
  end

  def try_again
    raise RetryService::Retry
  end

  def try_upload_entry_group eg_name, eg_stream
    result = execute_post eg_name, eg_stream
      require 'pry'
      binding.pry
    return result if result && result.status < 400
    @response = result.body
    try_again
  end

  def upload zip_service
    entry_group_streams = zip_service.entry_group_streams
    @workbench_import.update_attributes total_steps: entry_group_streams.size
    entry_group_streams.each_with_index(&method(:upload_entry_group))
  rescue StopIteration
    @workbench_import.update_attributes( current_step: entry_group_streams.size, status: 'failed' )
  end

  def upload_entry_group entry_pair, element_count
    @workbench_import.update_attributes( current_step: element_count.succ )
    retry_service = RetryService.new(
      delays: RETRY_DELAYS,
      rescue_from: [HTTPService::Timeout],
      &method(:log_failure)) 
    status = retry_service.execute(&upload_entry_group_proc(entry_pair))
    raise StopIteration unless status.ok?
  end

  def upload_entry_group_proc entry_pair
    eg_name, eg_stream = entry_pair
    # This should be fn.try_upload_entry_group(eg_name, eg_stream) ;(
    -> do
      try_upload_entry_group(eg_name, eg_stream)
    end
  end



  # Queries
  # =======

  def complete_entry_group_name entry_group_name
    [@workbench_import.name, entry_group_name].join("--")
  end

  def token entry_group_name
    Api::V1::ApiKey.from(@workbench_import.referential, name: complete_entry_group_name(entry_group_name)).token
  end

  # Constants
  # =========

  def export_host
    Rails.application.config.rails_host
  end
  def export_path
    api_v1_netex_imports_path(format: :json)
  end
  def export_url
    @__export_url__ ||= File.join(export_host, export_path)
  end

  def import_host
    Rails.application.config.rails_host
  end
  def import_path
    @__import_path__ ||= download_workbench_import_path(@workbench_import.workbench, @workbench_import)
  end
  def import_url
    @__import_url__ ||= File.join(import_host, import_path)
  end

  def params
    @__params__ ||= { netex_import: { referential_id: @workbench_import.referential_id, workbench_id: @workbench_import.workbench_id } }
  end
end

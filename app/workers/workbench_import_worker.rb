class WorkbenchImportWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers
  include Configurable

  attr_reader :import, :downloaded

  def perform(import_id)
    @import = Import.find(import_id)
    @downloaded = nil
    download
  end

  def download
    logger.warn  "HTTP GET #{import_url}"
    zipfile_data = AF83::HTTPFetcher.get_resource(
      host: import_host,
      path: import_path,
      params: {token: import.token_download})

    path = File.join(config.dir, import.name.gsub(%r{\s+}, '-'))
    unique_path = FileService.unique_filename path
    Dir.mkdir unique_path
    @downloaded = File.join(unique_path, import.name)
    File.open(downloaded, 'wb') do | file |
      file.write zipfile_data
    end

    if single_entry?
      upload(downloaded)
    else
      split_zip.each(&method(:upload))
    end
  end


  def single_entry?
    true
  end

  def split_zip
    []
  end

  def upload zip_file
  end

  # Memoized Values

  def dirname
    @__dirname__ ||= make_unique_dir
  end

  def import_host
    @__import_host__ ||= Rails.application.config.front_end_host
  end
  def import_path
    @__import_path__ ||= File.join(download_workbench_import_path(import.workbench, import)) 
  end
  def import_uri
    @__import_uri__ ||= URI(import_url) 
  end
  def import_url
    @__import_url__ ||= File.join(import_host, import_path)
  end

end

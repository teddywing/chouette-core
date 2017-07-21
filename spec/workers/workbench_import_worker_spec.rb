RSpec.describe WorkbenchImportWorker, type: [:worker, :request] do

  let( :worker ) { described_class.new }
  let( :import ){ build_stubbed :import, token_download: download_token, file: File.open(zip_file) }
  let( :workbench ){ import.workbench }
  let( :referential ){ import.referential }

  # http://www.example.com/workbenches/:workbench_id/imports/:id/download
  let( :url ){ "#{File.join(host, path)}?token=#{download_token}" }
  let( :host ){ Rails.configuration.front_end_host }
  let( :path ){ download_workbench_import_path(workbench, import) }

  let( :result ){ import.file.read }
  let( :download_token ){ SecureRandom.urlsafe_base64 }

  before do
    # That should be `build_stubbed's` job, no?
    allow(Import).to receive(:find).with(import.id).and_return(import)
  end


  context 'multireferential zipfile' do 
    let( :zip_file ){ File.join(fixture_path, 'multiref.zip') }

    it 'downloads a zip file' do
      default_headers = {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}
      stub_request(:get, url)
        .with(headers: default_headers)
        .to_return(body: result)

      worker.perform import.id

      expect( File.read(worker.downloaded) ).to eq( result )
      expect( worker ).not_to be_single_entry
    end
  end

  context 'unireferential zipfile' do 
    let( :zip_file ){ File.join(fixture_path, 'uniref.zip') }

    it 'downloads a zip file' do
      default_headers = {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}
      stub_request(:get, url)
        .with(headers: default_headers)
        .to_return(body: result)

      worker.perform import.id

      expect( File.read(worker.downloaded) ).to eq( result )
      expect( worker ).to be_single_entry
    end
  end

end

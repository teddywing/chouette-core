RSpec.describe WorkbenchImportWorker, type: [:worker, :request] do

  let( :worker ) { described_class.new }
  let( :import ){ build_stubbed :import, token_download: download_token, file: zip_file }

  let( :workbench ){ import.workbench }
  let( :referential ){ import.referential }
  let( :api_key ){ build_stubbed :api_key, referential: referential, token: "#{referential.id}-#{random_hex}" }

  # http://www.example.com/workbenches/:workbench_id/imports/:id/download
  let( :host ){ Rails.configuration.rails_host }
  let( :path ){ download_workbench_import_path(workbench, import) }

  let( :downloaded_zip ){ double("downloaded zip") }
  let( :download_zip_response ){ OpenStruct.new( body: downloaded_zip ) }
  let( :download_token ){ random_string }

  let( :upload_path ) { api_v1_netex_imports_path(format: :json) }

  let( :spurious ){ [[], [], []] }
  let( :subdirs ) do
    entry_count.times.map do |i|
      ZipService::Subdir.new(
        "subdir #{i}",
        double("subdir #{i}", rewind: 0, read: ''),
        spurious[i]
      )
    end
  end

  let( :zip_service ){ double("zip service") }
  let( :zip_file ){ open_fixture('multiple_references_import.zip') }

  let( :post_response_ok ){ double(status: 201, body: "{}") }

  before do
    Timecop.freeze(Time.now)

    # Silence Logger
    allow_any_instance_of(Logger).to receive(:info)
    allow_any_instance_of(Logger).to receive(:warn)

    # That should be `build_stubbed's` job, no?
    allow(Import).to receive(:find).with(import.id).and_return(import)

    allow(Api::V1::ApiKey).to receive(:from).and_return(api_key)
    allow(ZipService).to receive(:new).with(downloaded_zip).and_return zip_service
    expect(zip_service).to receive(:subdirs).and_return(subdirs)
    expect( import ).to receive(:update).with(
      status: 'running',
      started_at: Time.now
    )
  end

  after do
    Timecop.return
  end


  context 'multireferential zipfile, no errors' do
    let( :entry_count ){ 2 }

    it 'downloads a zip file, cuts it, and uploads all pieces' do

      expect(HTTPService).to receive(:get_resource)
        .with(host: host, path: path, params: {token: download_token})
        .and_return( download_zip_response )

      subdirs.each do |subdir|
        mock_post subdir, post_response_ok
      end

      expect( import ).to receive(:update).with(total_steps: 2)
      expect( import ).to receive(:update).with(current_step: 1)
      expect( import ).to receive(:update).with(current_step: 2)
      expect( import ).to receive(:update).with(ended_at: Time.now)

      worker.perform import.id

    end
  end

  context 'multireferential zipfile with error' do
    let( :entry_count ){ 3 }
    let( :post_response_failure ){ double(status: 406, body: {error: 'What was you thinking'}) }

    it 'downloads a zip file, cuts it, and uploads some pieces' do
      expect(HTTPService).to receive(:get_resource)
        .with(host: host, path: path, params: {token: download_token})
        .and_return( download_zip_response )

      # First subdir succeeds
      subdirs[0..0].each do |subdir|
        mock_post subdir, post_response_ok
      end

      # Second subdir fails (M I S E R A B L Y)
      subdirs[1..1].each do |subdir|
        mock_post subdir, post_response_failure
      end

      expect( import ).to receive(:update).with(total_steps: 3)
      expect( import ).to receive(:update).with(current_step: 1)
      expect( import ).to receive(:update).with(current_step: 2)
      expect( import ).to receive(:update).with(current_step: 3, status: 'failed')

      expect { worker.perform import.id }.to raise_error(StopIteration)
    end
  end

  context 'multireferential zipfile with spurious directories' do 
    let( :entry_count ){ 2 }
    let( :spurious1 ){ [random_string] }
    let( :spurious2 ){ [random_string, random_string] }
    let( :spurious ){ [spurious1, spurious2] }
    let( :messages ){ double('messages') }

    before do
      allow(import).to receive(:messages).and_return(messages)
    end

    it 'downloads a zip file, cuts it, and uploads all pieces and adds messages' do

      expect(HTTPService).to receive(:get_resource)
        .with(host: host, path: path, params: {token: download_token})
        .and_return( download_zip_response )

      subdirs.each do |subdir|
        mock_post subdir, post_response_ok
      end

      expect( import ).to receive(:update).with(total_steps: 2)
      expect( import ).to receive(:update).with(current_step: 1)
      expect( messages ).to receive(:create).with(criticity: :warning, message_key: 'xxx')
      expect( import ).to receive(:update).with(current_step: 2)
      expect( messages ).to receive(:create).with(criticity: :warning, message_key: 'xxx')
      expect( import ).to receive(:update).with(ended_at: Time.now)

      worker.perform import.id

    end
    
  end

  def mock_post subdir, response
    allow(HTTPService).to receive(:upload)
    expect( HTTPService ).to receive(:post_resource)
      .with(
        host: host,
        path: upload_path,
        params: {
          netex_import: {
            parent_id: import.id,
            parent_type: import.class.name,
            workbench_id: workbench.id,
            name: subdir.name,
            file: HTTPService.upload(
              subdir.stream,
              'application/zip',
              "#{subdir.name}.zip"
            )
          }
        }
      ).and_return(response)
  end
end

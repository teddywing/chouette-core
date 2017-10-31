RSpec.describe WorkbenchImportWorker do

  shared_examples_for 'corrupt zipfile data' do
    subject { described_class.new }
    let( :workbench_import ){ create :workbench_import, status: :pending }

    before do
      # Let us make sure that the name Enterprise will never be forgotten by history,
      # ahem, I meant, that nothing is uploaded, by forbidding any message to be sent
      # to HTTPService
      expect_it.to receive(:download).and_return(downloaded)
    end

    it 'does not upload' do
      stub_const 'HTTPService', double('HTTPService')
      subject.perform(workbench_import.id)
    end

    it 'does create a message' do
      expect{ subject.perform(workbench_import.id) }.to change{ workbench_import.messages.count }.by(1)

      message = workbench_import.messages.last
      expect( message.criticity ).to eq('error')
      expect( message.message_key ).to eq('corrupt_zip_file')
      expect( message.message_attributes ).to eq( 'source_filename' => workbench_import.name )
    end

    it 'does not change current step' do
      expect{ subject.perform(workbench_import.id) }.not_to change{ workbench_import.current_step }
    end

    it "sets the workbench_import.status to failed" do
      subject.perform(workbench_import.id)
      expect( workbench_import.reload.status ).to eq('failed')
    end
  end

  context 'empty zip file' do 
    let( :downloaded ){ '' }
    it_should_behave_like 'corrupt zipfile data'
  end

  context 'corrupt data' do 
    let( :downloaded ){ very_random }
    it_should_behave_like 'corrupt zipfile data'
  end
end

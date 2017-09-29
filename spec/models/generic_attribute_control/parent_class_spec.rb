RSpec.describe ComplianceControl do
  context 'class attributes' do 
    it 'are correctly set' do
      expect( described_class.default_criticity ).to eq( :warning )
      expect( described_class.default_code ).to eq( "" )
    end
  end
end

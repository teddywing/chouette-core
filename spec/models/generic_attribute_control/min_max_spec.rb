RSpec.describe GenericAttributeControl::MinMax do
  context 'class attributes' do 
    it 'are correctly set' do
      expect( described_class.default_criticity ).to eq(:warning)
      expect( described_class.default_code).to eq("3-Generic-2")
    end
  end
end

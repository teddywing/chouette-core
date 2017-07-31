RSpec.describe Result do

  context 'is a wrapper of a value' do 
    it { expect( described_class.ok('hello').value ).to eq('hello') }
    it { expect( described_class.error('hello').value ).to eq('hello') }
  end

  context 'it has status information' do 
    it { expect( described_class.ok('hello') ).to be_ok }
    it { expect( described_class.ok('hello').status ).to eq(:ok) }

    it { expect( described_class.error('hello') ).not_to be_ok }
    it { expect( described_class.error('hello').status ).to eq(:error) }
  end
  
  context 'nil is just another value' do
    it { expect( described_class.ok(nil) ).to be_ok }
    it { expect( described_class.ok(nil).value ).to be_nil }
  end
end

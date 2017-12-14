RSpec.describe CommonHelper do

  subject do
    Object.new.extend( described_class )
  end

  describe 'string_keys_to_symbols' do 
    context 'nullpotency on symbol keys' do
      it { expect(subject.string_keys_to_symbols({})).to eq({}) }
      it do
        expect(subject.string_keys_to_symbols(
          a: 1, b: 2
        )).to  eq(a: 1, b: 2)
      end
    end

    context 'changing string keys' do 
      it { expect(subject.string_keys_to_symbols('alpha' => 100)).to eq(alpha: 100) }
      
      it do
        expect( subject.string_keys_to_symbols('a' => 10, b: 20) )
          .to eq(a: 10, b: 20)
      end
      it do
        expect( subject.string_keys_to_symbols('a' => 10, 'b' => 20) )
          .to eq(a: 10, b: 20)
      end
    end

    context 'keys, not values, are changed' do
      it do
        expect(subject.string_keys_to_symbols(a: 'a', 'b' => 'b', 'c' => :c))
          .to eq(a: 'a', b: 'b', c: :c) 
      end
    end


  end
end

RSpec.describe ErrorFormat do
  
  context '#details' do 
    context 'are empty' do 
      it 'if no errors are present' do
        expect( described_class.details(create :referential) ).to be_empty
      end

      it 'if no validation has been carried out' do
        invalid = build :referential, name: nil
        expect( described_class.details(invalid) ).to be_empty
      end
    end

    context 'are not empty' do 
      it 'if an error is present and validation has been carried out' do
        invalid = build :referential, name: nil
        expect( invalid ).not_to be_valid
        expect( described_class.details(invalid) ).to eq([
          {name: {error: 'doit être rempli(e)', value: nil}}
        ])
      end

      it 'and can even hold many errors' do
        create :referential, name: 'hello'
        invalid = build :referential, name: 'hello', slug: 'hello world'
        expect( invalid ).not_to be_valid
        expect( described_class.details(invalid) ).to eq([
          {name: {error: "n'est pas disponible", value: 'hello'}},
          {slug: {error: "n'est pas valide", value: 'hello world'}}
        ])
      end
    end
  end
end

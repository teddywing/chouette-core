RSpec.describe NetexImport, type: :model do

  let( :invoked_calls ){ [] }

  let( :http_service ){ double 'Net::HTTP' }
  before do
    stub_const 'Net::HTTP', http_service
    allow(http_service).to receive( :get ){ invoked_calls << :called }
  end

  context 'with referential' do
    subject { build :netex_import }
    it 'will trigger the Java API' do
      subject.save
      expect( invoked_calls ).to eq([:called])
    end
  end

  context 'without referential' do
    subject { build :netex_import, referential_id: nil }

    it 'its status is forced to aborted and the Java API is not callled' do
      subject.save!
      expect( subject.reload.status ).to eq('aborted')
      expect( invoked_calls ).to be_empty
    end

  end

end

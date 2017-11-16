RSpec.describe NetexImport, type: :model do

  let( :boiv_iev_uri ){  URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/importer/new?id=#{subject.id}")}

  before do
    allow(Thread).to receive(:new).and_yield
  end

  context 'with referential' do
    subject{ build( :netex_import, id: random_int ) }

    it 'will trigger the Java API' do
      with_stubbed_request(:get, boiv_iev_uri) do |request|
        subject.save!
        expect(request).to have_been_requested
      end
    end
  end

  context 'without referential' do
    subject { build :netex_import, referential_id: nil }

    it 'its status is forced to aborted and the Java API is not callled' do
      with_stubbed_request(:get, boiv_iev_uri) do |request|
        subject.save!
        expect(subject.reload.status).to eq('aborted')
        expect(request).not_to have_been_requested
      end
    end
  end

end

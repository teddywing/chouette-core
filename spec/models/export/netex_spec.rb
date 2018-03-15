RSpec.describe Export::Netex, type: [:model, :with_commit] do

  let( :boiv_iev_uri ){  URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/exporter/new?id=#{subject.id}")}

  before do
    allow(Thread).to receive(:new).and_yield
  end

  context 'with referential' do
    subject{ build( :netex_export, id: random_int ) }

    it 'will trigger the Java API' do
      with_stubbed_request(:get, boiv_iev_uri) do |request|
        with_commit{ subject.save! }
        expect(request).to have_been_requested
      end
    end
  end
end

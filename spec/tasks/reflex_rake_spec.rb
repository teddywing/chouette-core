require 'spec_helper'

describe 'reflex:sync' do
  before(:all) do
    ['getOP', 'getOR'].each do |method|
      stub_request(:get, "https://reflex.stif.info/ws/reflex/V1/service=getData/?format=xml&idRefa=0&method=#{method}").
      to_return(body: File.open("#{fixture_path}/reflex.zip"), status: 200)
    end
  end

  it 'should create stopArea on successfull request' do
    # Must have an stop_area_referential
    create(:stop_area_referential, name: 'Reflex')
    Stif::ReflexSynchronization.synchronize
    expect(Chouette::StopArea.count).to eq 7928
    expect(Chouette::AccessPoint.count).to eq 60
  end
end

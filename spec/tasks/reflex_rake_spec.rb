require 'spec_helper'

describe 'test' do
  before(:all) do
    ['getOP', 'getOR'].each do |method|
      stub_request(:get, "https://reflex.stif.info/ws/reflex/V1/service=getData/?format=xml&idRefa=0&method=#{method}").
      to_return(body: File.open("#{fixture_path}/reflex.zip"), status: 200)
    end
  end

  context 'process stop area sync' do
    it 'should return results on valid request' do
      start = Time.now
      # Must have a referential
      create(:stop_area_referential, name: 'Reflex')

      Stif::ReflexSynchronization.synchronize_stop_area
      Rails.logger.debug "Reflex-api sync done in #{Time.now - start} seconds !"
    end
  end
end

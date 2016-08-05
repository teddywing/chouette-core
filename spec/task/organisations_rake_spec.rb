require 'rails_helper'
require 'rake'

describe 'organisations:sync rake task' do
  before :all do
    Rake.application.rake_require "tasks/organisations"
    Rake::Task.define_task(:environment)
  end

  describe 'organisations:sync' do
    let(:conf) { Rails.application.config.stif_portail_api }
    let :run_rake_task do
      Rake::Task["organisations:sync"].reenable
      Rake.application.invoke_task "organisations:sync"
    end

    before :each do
      stub_request(:get, "#{conf[:url]}/api/v1/organizations").
        with(headers: { 'Authorization' => "Token token=\"#{conf[:key]}\"" }).
        to_return(body: File.open(File.join(Rails.root, 'spec', 'fixtures', 'organizations.json')), status: 200)
    end

    it 'should create new organisations' do
      expect{run_rake_task}.to change{ Organisation.count }.by(5)
      expect(WebMock).to have_requested(:get, "#{conf[:url]}/api/v1/organizations").
        with(headers: { 'Authorization' => "Token token=\"#{conf[:key]}\"" })

      expect(Organisation.all.map(&:name)).to include 'ALBATRANS', 'OPTILE', 'SNCF', 'STIF'
    end

    it 'should update existing organisations' do
      create :organisation, name: 'dummy_name', code:'RATP', updated_at: 10.days.ago
      run_rake_task

      Organisation.find_by(code: 'RATP').tap do |org|
        expect(org.name).to eq('RATP')
        expect(org.updated_at.utc).to be_within(1.second).of Time.now
        expect(org.synced_at.utc).to be_within(1.second).of Time.now
      end
    end

    it 'should not create organisation if code is already present' do
      create :organisation, code:'RATP'
      expect{run_rake_task}.to change{ Organisation.count }.by(4)
    end
  end
end

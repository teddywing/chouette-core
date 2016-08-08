require 'rails_helper'
require 'rake'

describe 'users:sync rake task' do
  before :all do
    Rake.application.rake_require "tasks/users"
    Rake::Task.define_task(:environment)
  end

  describe 'users:sync' do
    let(:conf) { Rails.application.config.stif_portail_api }
    let :run_rake_task do
      Rake::Task["users:sync"].reenable
      Rake.application.invoke_task "users:sync"
    end

    before :each do
      stub_request(:get, "#{conf[:url]}/api/v1/users").
        with(headers: { 'Authorization' => "Token token=\"#{conf[:key]}\"" }).
        to_return(body: File.open(File.join(Rails.root, 'spec', 'fixtures', 'users.json')), status: 200)
    end

    it 'should create new users' do
      run_rake_task
      expect(WebMock).to have_requested(:get, "#{conf[:url]}/api/v1/users").
        with(headers: { 'Authorization' => "Token token=\"#{conf[:key]}\"" })
      expect(User.count).to eq(11)
      expect(Organisation.count).to eq(3)
    end

    it 'should update existing users' do
      create :user, username: 'alban.peignier', email:'dummy@example.com', updated_at: 10.days.ago
      run_rake_task
      user = User.find_by(username: 'alban.peignier')

      expect(user.name).to eq('Alban Peignier')
      expect(user.email).to eq('alban.peignier@af83.com')
      expect(user.updated_at.utc).to be_within(1.second).of Time.now
      expect(user.synced_at.utc).to be_within(1.second).of Time.now
    end

    it 'should update organisation assignement' do
      create :user, username: 'alban.peignier', organisation: create(:organisation)
      run_rake_task
      expect(User.find_by(username: 'alban.peignier').organisation.name).to eq("STIF")
    end

    it 'should update locked_at attribute' do
      create :user, username: 'alban.peignier', locked_at: Time.now
      run_rake_task
      expect(User.find_by(username: 'alban.peignier').locked_at).to be_nil
      expect(User.find_by(username: 'jane.doe').locked_at).to eq("2016-08-05T12:34:03.995Z")
    end

    it 'should not create new user if username is already present' do
      create :user, username: 'alban.peignier'
      run_rake_task
      expect(User.count).to eq(11)
    end
  end
end

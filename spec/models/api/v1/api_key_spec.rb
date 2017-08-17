require 'rails_helper'

RSpec.describe Api::V1::ApiKey, type: :model do
  subject { create(:api_key) }

  it { should validate_presence_of :organisation }

  it 'should have a valid factory' do
    expect(build(:api_key)).to be_valid
  end

  describe '#referential_from_token' do
    it 'should return referential' do
      referential = Api::V1::ApiKey.referential_from_token(subject.token)
      expect(referential).to eq(subject.referential)
    end
  end

  describe '#organisation_from_token' do
    it 'should return organisation' do
      organisation = Api::V1::ApiKey.organisation_from_token(subject.token)
      expect(organisation).to eq(subject.organisation)
    end
  end
end

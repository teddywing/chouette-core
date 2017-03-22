require 'rails_helper'

RSpec.describe ImportResource, :type => :model do
  it { should belong_to(:import) }

  it { should enumerize(:status).in(:new, :pending, :successful, :failed) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:reference) }

  describe 'states' do
    let(:import_resource) { create(:import_resource) }

    it 'should initialize with new state' do
      expect(import_resource.new?).to be_truthy
    end
  end
end

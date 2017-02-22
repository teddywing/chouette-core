require 'rails_helper'

RSpec.describe ImportResource, :type => :model do
  it { should belong_to(:import) }

  describe 'states' do
    let(:import_resource) { create(:import_resource) }

    it 'should initialize with new state' do
      expect(import_resource.new?).to be_truthy
    end
  end
end

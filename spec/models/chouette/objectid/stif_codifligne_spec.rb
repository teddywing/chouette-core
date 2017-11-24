require 'spec_helper'

describe Chouette::Objectid::StifCodifligne, :type => :model do
  subject { Chouette::Objectid::StifCodifligne.new(object_type: 'Line', local_id: 'C02008', sync_id: 'CODIFLIGNE', provider_id: 'STIF') }
  it { should validate_presence_of :provider_id }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :local_id }
  it { should validate_presence_of :sync_id }
  it { is_expected.to be_valid }
end
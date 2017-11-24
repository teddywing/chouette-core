require 'spec_helper'

describe Chouette::Objectid::StifReflex, :type => :model do
  subject { Chouette::Objectid::StifReflex.new(country_code: 'FR', zip_code: '78517', object_type: 'ZDL', local_id: '50015386', provider_id: 'STIF') }
  it { should validate_presence_of :provider_id }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :local_id }
  it { should validate_presence_of :country_code }
  it { should validate_presence_of :zip_code }
  it { is_expected.to be_valid }
end
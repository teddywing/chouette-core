require 'spec_helper'

describe Chouette::Objectid::Netex, :type => :model do
  subject { Chouette::Objectid::Netex.new(object_type: 'Route', local_id: SecureRandom.uuid) }
  it { should validate_presence_of :provider_id }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :local_id }
  it { should validate_presence_of :creation_id }
  it { is_expected.to be_valid }
end
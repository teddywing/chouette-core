require 'spec_helper'

describe Chouette::RoutingConstraintZone, type: :model do

  subject { create(:routing_constraint_zone) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :stop_area_ids }
  it { is_expected.to validate_presence_of :line_id }
  # shoulda matcher to validate length of array ?
  xit { is_expected.to validate_length_of(:stop_area_ids).is_at_least(2) }

end

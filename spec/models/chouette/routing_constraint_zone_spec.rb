require 'spec_helper'

describe Chouette::RoutingConstraintZone, type: :model do

  subject { create(:routing_constraint_zone) }

  it { is_expected.to validate_presence_of :name }
  # shoulda matcher to validate length of array ?
  xit { is_expected.to validate_length_of(:stop_point_ids).is_at_least(2) }

  describe 'validations' do
    it 'validates the presence of route_id' do
      routing_constraint_zone = create(:routing_constraint_zone)
      expect {
        routing_constraint_zone.update!(route_id: nil)
      }.to raise_error
    end

    it 'validates the presence of stop_point_ids' do
      routing_constraint_zone = create(:routing_constraint_zone)
      expect {
        routing_constraint_zone.update!(stop_point_ids: [])
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'validates that stop points belong to the route' do
      routing_constraint_zone = create(:routing_constraint_zone)
      route = create(:route)
      expect {
        routing_constraint_zone.update!(route_id: route.id)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'deleted stop areas' do
    it 'does not have them in stop_area_ids' do
      routing_constraint_zone = create(:routing_constraint_zone)
      stop_point = routing_constraint_zone.route.stop_points.last
      routing_constraint_zone.stop_points << stop_point
      routing_constraint_zone.save!
      routing_constraint_zone.route.stop_points.last.destroy!
      expect(routing_constraint_zone.stop_points.map(&:id)).not_to include(stop_point.id)
    end
  end

end

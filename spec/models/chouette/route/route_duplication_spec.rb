# From Chouette import what we need ™
Route     = Chouette::Route
StopArea  = Chouette::StopArea
StopPoint = Chouette::StopPoint

RSpec.describe Route do

  let!( :route ){ create :route }
  let( :new_objectid ){ [SecureRandom.hex, 'Route', SecureRandom.hex].join(':') }

  context 'duplicates' do 
    describe 'a route' do
      it 'by creating a new one' do
        expect{ route.duplicate new_objectid }.to change{Route.count}.by(1)
      end
      it 'with the same values' do
        route.duplicate new_objectid
        expect( values_for_create(Route.last, except: %w{objectid}) ).to eq( values_for_create( route, except: %w{objectid} ) )
      end

      it 'and also duplicating its stop points' do
        expect{ route.duplicate new_objectid }.to change{StopPoint.count}.by(route.stop_points.count)
      end
      it 'but leaving the stop areas alone' do
        expect{ route.duplicate new_objectid }.not_to change{StopArea.count}
      end
      it "which are still accessible by the new route though" do
        expect( route.duplicate( new_objectid ).stop_areas.pluck(:id) ).to eq(route.stop_areas.pluck(:id))
      end
    end
  end

end

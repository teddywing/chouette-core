# From Chouette import what we need ™
Route     = Chouette::Route
StopArea  = Chouette::StopArea
StopPoint = Chouette::StopPoint

RSpec.describe Route do

  let!( :route ){ create :route }

  context '#duplicate' do 
    describe 'properties' do
      it 'same attribute values' do
        route.duplicate
        expect( values_for_create(Route.last, except: %w{objectid}) ).to eq( values_for_create( route, except: %w{objectid} ) )
      end
      it 'and others cannot' do
        expect{ route.duplicate name: 'YAN', line_id: 42  }.to raise_error(ArgumentError)
      end
      it 'same associated stop_areeas' do
        expect( route.duplicate.stop_areas.pluck(:id) ).to eq(route.stop_areas.pluck(:id))
      end
    end

    describe 'side_effects' do
      it {
        expect{ route.duplicate }.to change{Route.count}.by(1)
      }
      it 'duplicates its stop points' do
        expect{ route.duplicate }.to change{StopPoint.count}.by(route.stop_points.count)
      end
      it 'does bot duplicate the stop areas' do
        expect{ route.duplicate }.not_to change{StopArea.count}
      end
    end

    describe 'is idempotent, concerning' do
      let( :first_duplicate ){ route.duplicate  }
      let( :second_duplicate ){ first_duplicate.reload.duplicate }

      it 'the required attributes' do
        expect( values_for_create(first_duplicate, except: %w{objectid}) ).to eq( values_for_create( second_duplicate, except: %w{objectid} ) )
      end 

      it 'the stop areas' do
        expect( first_duplicate.stop_areas.pluck(:id) ).to eq( route.stop_areas.pluck(:id) )
        expect( second_duplicate.stop_areas.pluck(:id) ).to eq( first_duplicate.stop_areas.pluck(:id) )
      end

    end
  end

end

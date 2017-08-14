# From Chouette import what we need ™
Route     = Chouette::Route
StopArea  = Chouette::StopArea
StopPoint = Chouette::StopPoint

RSpec.describe Route do

  let( :route ){ create :route }

  context 'duplicates' do 
    describe 'a route' do
      it 'by creating a new one' do
        expect{ route.duplicate }.to change{Route.count}.by(1)
      end
      it 'with the same values' do
        expect( values_for_create(Route.last) ).to eq( values_for_create( route ) )
      end

    it 'and also duplicating its stop points' do
      expect{ route.dublicate }.to change{StopPoint.count}.by(route.stop_points.count)
    end
    it 'but leaving the stop areas alone' do
      expect{ route.duplicate }.not_to change{StopArea.count}
    end
    it "which are still accessible by the new route though" do
      expect( route.duplicate.stop_areas ).to eq(route.stop_areas)
    end
    end
  end
  
end

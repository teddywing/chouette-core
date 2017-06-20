RSpec.describe CalendarsController, type: :controller do
  login_user
  describe 'POST /create' do

    context 'legal date' do
      let( :params ){ {
        "calendar"=>{"name"=>"cal", "short_name"=>"cal", "shared"=>"false", 
                     "date_values_attributes"=>{"1497892917360"=>{"value(3i)"=>"19", "value(2i)"=>"6", "value(1i)"=>"2017", "_destroy"=>""}}}
      } }

      it 'creates the calendar and redirects to show' do
        expect{ post :create, params }.to change{Calendar.count}.by 1
        expect( response ).to redirect_to( calendar_path( Calendar.last ) )
      end
    end

    context 'illegal date' do
      let( :params ){ {
        "calendar"=>{"name"=>"cal", "short_name"=>"cal", "shared"=>"false", 
                     "date_values_attributes"=>{"1497892917360"=>{"value(3i)"=>"31", "value(2i)"=>"6", "value(1i)"=>"2017", "_destroy"=>""}}}
      } }

      it 'does not create the calendar and redircets to new' do
        post :create, params
        expect{ post :create, params }.not_to change{Calendar.count}
        expect( response ).to redirect_to( new_calendar_path )
      end
    end

  end 
end

RSpec.describe "NetexImport", type: :request do

  describe 'POST netex_imports' do

    let( :referential ){ create :referential }

    let( :file_path ){'spec/fixtures/neptune.zip'}
    let( :file ){ fixture_file_upload( file_path ) }

    let( :post_request ) do
      -> (attributes) do
        post "/api/v1/netex_imports.json",
          attributes,
          authorization
      end
    end

    let( :legal_attributes ){ {
      netex_import: {
        name: 'hello world',
        file: file,
        referential_id: referential.id}
    } }

    let( :illegal_attributes ){ {
      netex_import: {
        referential_id: referential.id}
    } }

    context 'with correct credentials and correct request' do
      let( :authorization ){ authorization_token_header( get_api_key.token ) }


      it 'succeeds' do
        post_request.(legal_attributes)
        expect( response ).to be_success
        expect( json_response_body ).to eq({'id' => NetexImport.last.id, 'type' => 'NetexImport'})
      end

      it 'creates a NetexImport object in the DB' do
        expect{ post_request.(legal_attributes) }.to change{NetexImport.count}.by(1)
      end
    end

    context 'with incorrect credentials and correct request' do
      let( :authorization ){ authorization_token_header( "#{referential.id}-incorrect_token") }

      it 'does not succeed' do
        post_request.(legal_attributes)
        expect( response.status ).to eq(401)
      end

      it 'does not create an Import object' do
        expect{ post_request.(legal_attributes) }.not_to change{Import.count}
      end
    end

    context 'with correct credentials and incorrect request' do
      let( :authorization ){ authorization_token_header( get_api_key.token ) }

      it 'does not succeed' do
        post_request.(illegal_attributes)
        expect( response.status ).to eq(406)
        expect( json_response_body['errors']['file'] ).not_to be_empty
      end

      it 'does not create an Import object' do
        expect{ post_request.(illegal_attributes) }.not_to change{Import.count}
      end
    end
  end
end

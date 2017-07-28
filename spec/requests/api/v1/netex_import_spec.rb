RSpec.describe "NetexImport", type: :request do

  describe 'POST netex_imports' do

    let( :referential ){ create :referential }
    let( :workbench ){ referential.workbench }


    let( :file_path ){ fixtures_path 'singleref.zip' }
    let( :file ){ fixture_file_upload( file_path ) }

    let( :post_request ) do
      -> (attributes) do
        post "/api/v1/netex_imports.json",
          attributes,
          authorization
      end
    end

    let( :legal_attributes ) do
      {
        name: 'hello world',
        file: file,
        referential_id: referential.id,
        workbench_id:   workbench.id
      }
    end 


    context 'with correct credentials and correct request' do
      let( :authorization ){ authorization_token_header( get_api_key.token ) }

      it 'succeeds' do
        post_request.(netex_import: legal_attributes)
        expect( response ).to be_success
        expect( json_response_body ).to eq({'id' => NetexImport.last.id, 'type' => 'NetexImport'})
      end

      it 'creates a NetexImport object in the DB' do
        expect{ post_request.(netex_import: legal_attributes) }.to change{NetexImport.count}.by(1)
      end

      it 'creates a correct Referential' do
        legal_attributes # force object creation for correct to change behavior
        expect{post_request.(netex_import: legal_attributes)}.to change{Referential.count}.by(1)
        Referential.last.tap do | ref |
          expect( ref.workbench_id ).to eq(workbench.id)
          expect( ref.organisation_id ).to eq(workbench.organisation_id)
        end
      end
    end

    context 'with incorrect credentials and correct request' do
      let( :authorization ){ authorization_token_header( "#{referential.id}-incorrect_token") }

      it 'does not succeed' do
        legal_attributes # force object creation for correct to change behavior
        expect{ post_request.(netex_import: legal_attributes) }.not_to change{Referential.count}
        expect( response.status ).to eq(401)
      end

      it 'does not create an Import object' do
        expect{ post_request.(netex_import: legal_attributes) }.not_to change{Import.count}
      end
    end

    context 'with correct credentials and incorrect request' do
      let( :authorization ){ authorization_token_header( get_api_key.token ) }

      shared_examples_for 'illegal attributes' do |bad_attribute, illegal_value=nil|
        context "missing #{bad_attribute}" do
          let!( :illegal_attributes ){ legal_attributes.merge( bad_attribute => illegal_value ) }
          it 'does not succeed' do
            post_request.(netex_import: illegal_attributes)
            expect( response.status ).to eq(406)
            expect( json_response_body['errors'][bad_attribute.to_s] ).not_to be_empty
          end

          it 'does not create an Import object' do
            expect{ post_request.(netex_import: illegal_attributes) }.not_to change{Import.count}
          end

          it 'does not create a new Referential' do
            expect{ post_request.(netex_import: illegal_attributes) }.not_to change{Referential.count}
          end
        end
      end

      it_behaves_like 'illegal attributes', :file
      it_behaves_like 'illegal attributes', :workbench_id
      context 'name already taken' do
        before do
          create :referential, name: 'already taken'
        end
        it_behaves_like 'illegal attributes', :name, 'already taken'
      end
    end
  end
end

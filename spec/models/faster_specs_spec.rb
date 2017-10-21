RSpec.describe 'Faster Specs', type: :faster do

  N = (ENV['N'] || 1).to_i

  shared_examples_for 'correct behavior' do

    N.times do
      it 'finds workbench' do
        expect( referential.workbench ).to eq(workbench)
      end

      it 'finds referentials' do
        expect( workbench.referentials ).to eq([referential])
      end
    end

  end

  context 'in DB' do 
    let( :workbench ){ create :workbench }
    let( :referential ){ create(:referential, workbench: workbench) }

    it_behaves_like 'correct behavior'
  end

  context 'stubbed' do 
    let( :workbench ){ stub_model Workbench }
    let( :referential ){ stub_model( Referential, workbench: workbench ) }

    it_behaves_like 'correct behavior'
  end

  context 'with FactoryGirl' do 
    let( :workbench ){ stub_model :workbench }
    let( :referential ){ stub_model( :referential, workbench: workbench ) }

    it_behaves_like 'correct behavior'
  end

  shared_examples_for 'meta' do |org_builder|
    context 'workbench belongs to organisation' do
      it 'workbench has no orgnaisation' do
        expect( workbench.organisation ).to be_nil
      end
      it 'but it can be set' do
        organisation = stub_model org_builder
        workbench.organisation = organisation
        expect( workbench.organisation ).to eq(organisation)
      end
      it 'and by setting it we get the reverse relation working' do
        organisation = stub_model org_builder
        workbench.organisation = organisation
        expect( organisation.workbenches ).to be_eql([workbench])
      end
      it 'can also be constructed that way' do
        organisation = stub_model org_builder
        workbench    = stub_model Workbench, organisation: organisation
        expect( workbench.organisation ).to eq(organisation)
        expect( organisation.workbenches ).to be_eql([workbench])
      end
    end
  end

  context 'ActiveRecordMeta' do
    let( :workbench ){ stub_model Workbench }

    it_behaves_like 'meta', Organisation
  end

  context 'FactoryGirlMeta' do
    let( :workbench ){ stub_model :workbench }

    it_behaves_like 'meta', :organisation

  end
end

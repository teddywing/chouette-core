RSpec.describe Import::BasePolicy, type: :policy do

  let( :record ){ build_stubbed :import }
  before { stub_policy_scope(record) }

  #
  #  Non Destructive
  #  ---------------

  context 'Non Destructive actions →' do
    permissions :index? do
      it_behaves_like 'always allowed', 'anything'
    end
    permissions :show? do
      it_behaves_like 'always allowed', 'anything'
    end
  end


  #
  #  Destructive
  #  -----------

  context 'Destructive actions →' do
    permissions :create? do
      it_behaves_like 'permitted policy', 'imports.create'
    end
    permissions :destroy? do
      it_behaves_like 'always forbidden', 'imports.destroy'
    end
    permissions :edit? do
      it_behaves_like 'permitted policy', 'imports.update'
    end
    permissions :new? do
      it_behaves_like 'permitted policy', 'imports.create'
    end
    permissions :update? do
      it_behaves_like 'permitted policy', 'imports.update'
    end
  end
end

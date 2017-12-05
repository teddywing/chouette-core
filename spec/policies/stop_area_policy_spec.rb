# coding: utf-8
RSpec.describe StopAreaPolicy, type: :policy do

  let( :record ){ build_stubbed :stop_area }
  before { stub_policy_scope(record) }


  #
  #  Non Destructive
  #  ---------------

  context 'Non Destructive actions →' do
    permissions :index? do
      it_behaves_like 'always allowed', 'anything', archived: true
    end
    permissions :show? do
      it_behaves_like 'always allowed', 'anything', archived: true
    end
  end


  #
  #  Destructive
  #  -----------

  context 'Destructive actions →' do
    permissions :create? do
      it_behaves_like 'permitted policy', 'stop_areas.create'
    end
    permissions :destroy? do
      it_behaves_like 'permitted policy', 'stop_areas.destroy'
    end
    permissions :edit? do
      it_behaves_like 'permitted policy', 'stop_areas.update'
    end
    permissions :new? do
      it_behaves_like 'permitted policy', 'stop_areas.create'
    end
    permissions :update? do
      it_behaves_like 'permitted policy', 'stop_areas.update'
    end
  end
end

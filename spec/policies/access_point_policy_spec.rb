RSpec.describe AccessPointPolicy, type: :policy do

  let( :record ){ build_stubbed :access_point }

  permissions :create? do
      it_behaves_like 'permitted policy and same organisation', "access_points.create", archived_and_finalised: true
  end
  permissions :destroy? do
      it_behaves_like 'permitted policy and same organisation', "access_points.destroy", archived_and_finalised: true
  end
  permissions :edit? do
      it_behaves_like 'permitted policy and same organisation', "access_points.update", archived_and_finalised: true
  end
  permissions :new? do
      it_behaves_like 'permitted policy and same organisation', "access_points.create", archived_and_finalised: true
  end
  permissions :update? do
      it_behaves_like 'permitted policy and same organisation', "access_points.update", archived_and_finalised: true
  end
end

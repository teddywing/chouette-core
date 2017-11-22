RSpec.describe AccessPointPolicy, type: :policy do

  let( :record ){ build_stubbed :access_point }

  permissions :create? do
      it_behaves_like 'permitted policy and same organisation', "access_points.create", archived: true
  end
  permissions :destroy? do
      it_behaves_like 'permitted policy and same organisation', "access_points.destroy", archived: true
  end
  permissions :edit? do
      it_behaves_like 'permitted policy and same organisation', "access_points.update", archived: true
  end
  permissions :new? do
      it_behaves_like 'permitted policy and same organisation', "access_points.create", archived: true
  end
  permissions :update? do
      it_behaves_like 'permitted policy and same organisation', "access_points.update", archived: true
  end
end

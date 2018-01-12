RSpec.describe ConnectionLinkPolicy, type: :policy do

  let( :record ){ build_stubbed :connection_link }

  permissions :create? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.create", archived_and_finalised: true
  end
  permissions :destroy? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.destroy", archived_and_finalised: true
  end
  permissions :edit? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.update", archived_and_finalised: true
  end
  permissions :new? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.create", archived_and_finalised: true
  end
  permissions :update? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.update", archived_and_finalised: true
  end
end

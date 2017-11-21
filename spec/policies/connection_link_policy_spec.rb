RSpec.describe Chouette::ConnectionLinkPolicy, type: :policy do

  let( :record ){ build_stubbed :connection_link }

  permissions :create? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.create", archived: true
  end
  permissions :destroy? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.destroy", archived: true
  end
  permissions :edit? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.update", archived: true
  end
  permissions :new? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.create", archived: true
  end
  permissions :update? do
      it_behaves_like 'permitted policy and same organisation', "connection_links.update", archived: true
  end
end

RSpec.describe Chouette::JourneyPatternPolicy, type: :policy do

  let( :record ){ build_stubbed :journey_pattern }

  permissions :create? do
      it_behaves_like 'permitted policy and same organisation', "journey_patterns.create", archived: true
  end
  permissions :destroy? do
      it_behaves_like 'permitted policy and same organisation', "journey_patterns.destroy", archived: true
  end
  permissions :edit? do
      it_behaves_like 'permitted policy and same organisation', "journey_patterns.update", archived: true
  end
  permissions :new? do
      it_behaves_like 'permitted policy and same organisation', "journey_patterns.create", archived: true
  end
  permissions :update? do
      it_behaves_like 'permitted policy and same organisation', "journey_patterns.update", archived: true
  end
end

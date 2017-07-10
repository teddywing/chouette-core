RSpec.describe Chouette::StopPoint do
  describe "using RoutePolicy" do
    it { expect( described_class.policy_class ).to eq(RoutePolicy)  }
  end
end

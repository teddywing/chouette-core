RSpec.describe ApplicationPolicy, type: :policy do

  subject { described_class }
  
  permissions :organisation_match? do
    let( :user_context ) { create_user_context(user: user, referential: referential)  }
    let( :referentail )  { create :referential }
    let( :user )         { create :user }

    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, referential)
    end

    it "allows a user with a different organisation" do
      user.update_attribute :organisation, referential.organisation
      expect_it.to permit(user_context, referential)
    end
  end
end

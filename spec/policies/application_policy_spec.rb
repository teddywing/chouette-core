RSpec.describe ApplicationPolicy, type: :policy do

  let( :user_context ) { create_user_context(user: user, referential: referential)  }
  let( :referentail )  { create :referential }
  let( :user )         { create :user }

  subject { described_class }
  
  permissions :organisation_match? do

    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, referential)
    end

    it "allows a user with a different organisation" do
      user.update_attribute :organisation, referential.organisation
      expect_it.to permit(user_context, referential)
    end
  end

  permissions :boiv_read_offer? do

    context "user of a different organisation → " do
      it "denies a user with a different organisation" do
        expect_it.not_to permit(user_context, referential)
      end
      it "even if she has the permisson" do
        add_permissions('boiv:read-offer', for_user: user)
        expect_it.not_to permit(user_context, referential)
      end
    end

    context "user of the same organisation → " do
      before do
        user.update_attribute :organisation, referential.organisation
      end
      it "denies if permission absent" do
        expect_it.not_to permit(user_context, referential)
      end
      it "allows if permission present" do
        add_permissions('boiv:read-offer', for_user: user)
        expect_it.to permit(user_context, referential)
      end
    end
  end
end

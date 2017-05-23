RSpec.shared_examples "permitted and same organisation" do |permission|

  context "permission absent → " do
    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, referential)
    end
    it "and also a user with the same organisation" do
      user.update_attribute :organisation, referential.organisation
      expect_it.not_to permit(user_context, referential)
    end
  end
  
  context "permission present → "  do
    before do
      add_permissions(permission, for_user: user)
    end

    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, referential)
    end

    it "but allows it for a user with the same organisation" do
      user.update_attribute :organisation, referential.organisation
      expect_it.to permit(user_context, referential)
    end
  end
end

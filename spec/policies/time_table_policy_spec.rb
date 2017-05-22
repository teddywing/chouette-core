RSpec.describe TimeTablePolicy, type: :policy do

  permissions :duplicate? do
    context "user of a different organisation" do
      it "is denied" do
        expect_it.not_to permit(user_context, referential)
      end
      it "even if she has the time_tables.create permission" do
        add_permissions 'time_tables.create', for_user: user
        expect_it.not_to permit(user_context, referential)
      end
    end
    context "user of the same organisation" do
      before do
        user.update_attribute :organisation, referential.organisation
      end
      it "is denied" do
        expect_it.not_to permit(user_context, referential)
      end
      it "unless she has the time_tables.create permission" do
        add_permissions 'time_tables.create', for_user: user
        expect_it.to permit(user_context, referential)
      end
    end
  end
end

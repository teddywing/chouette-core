RSpec.describe CalendarPolicy, type: :policy do

  let( :record ){ build_stubbed :calendar }

  shared_examples 'authorizes on archived and same organisation only' do
    | permission, archived: false|
    context 'same organisation →' do
      before do
        user.organisation_id = referential.organisation_id
      end
      it "allows a user with the same organisation" do
        expect_it.to permit(user_context, record)
      end
      if archived
        it 'removes permission for archived referentials' do
          referential.archived_at = 42.seconds.ago
          expect_it.not_to permit(user_context, record)
        end
      end
    end

    context 'different organisations →' do
      before do
        add_permissions(permission, for_user: user)
      end
      it "denies a user with a different organisation" do
        expect_it.not_to permit(user_context, record)
      end
    end
  end

  permissions :create? do
    it_behaves_like 'authorizes on archived and same organisation only', 'calendars.create', archived: true
  end
  permissions :destroy? do
    it_behaves_like 'authorizes on archived and same organisation only', 'calendars.destroy', archived: true
  end
  permissions :edit? do
    it_behaves_like 'authorizes on archived and same organisation only', 'calendars.update', archived: true
  end
  permissions :new? do
    it_behaves_like 'authorizes on archived and same organisation only', 'calendars.create', archived: true
  end
  permissions :update? do
    it_behaves_like 'authorizes on archived and same organisation only', 'calendars.update', archived: true
  end
end

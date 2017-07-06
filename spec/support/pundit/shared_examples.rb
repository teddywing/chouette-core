RSpec.shared_examples 'permitted policy and same organisation' do
  | permission, archived: false|

  context 'permission absent → ' do
    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, record)
    end
    it 'and also a user with the same organisation' do
      user.organisation = referential.organisation
      expect_it.not_to permit(user_context, record)
    end
  end
  
  context 'permission present → '  do
    before do
      add_permissions(permission, for_user: user)
    end

    it 'denies a user with a different organisation' do
      expect_it.not_to permit(user_context, record)
    end

    it 'but allows it for a user with the same organisation' do
      user.organisation = referential.organisation
      expect_it.to permit(user_context, record)
    end

    if archived
      it 'removes the permission for archived referentials' do
        user.organisation = referential.organisation
        referential.archived_at = 42.seconds.ago
        expect_it.not_to permit(user_context, record)
      end
    end
  end
end

RSpec.shared_examples 'permitted policy' do
  | permission, archived: false|
  context 'permission absent → ' do
    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, record)
    end
  end
  context 'permission present → '  do
    before do
      add_permissions(permission, for_user: user)
    end
    it 'allows a user with a different organisation' do
      expect_it.to permit(user_context, record)
    end

    if archived
      it 'removes the permission for archived referentials' do
        referential.archived_at = 42.seconds.ago
        expect_it.not_to permit(user_context, record)
      end
    end
  end
end

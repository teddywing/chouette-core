RSpec.shared_examples 'permitted policy and same organisation' do
  | permission, restricted_ready: false|

  context 'permission absent → ' do
    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, referential)
    end
    it 'and also a user with the same organisation' do
      user.update_attribute :organisation, referential.organisation
      expect_it.not_to permit(user_context, referential)
    end
  end
  
  context 'permission present → '  do
    before do
      add_permissions(permission, for_user: user)
    end

    it 'denies a user with a different organisation' do
      expect_it.not_to permit(user_context, referential)
    end

    it 'but allows it for a user with the same organisation' do
      user.update_attribute :organisation, referential.organisation
      expect_it.to permit(user_context, referential)
    end

    if restricted_ready
      it 'removes the permission for archived referentials' do
        user.update_attribute :organisation, referential.organisation
        referential.update_attribute :ready, true
        expect_it.not_to permit(user_context, referential)
      end
    end
  end
end

RSpec.shared_examples 'permitted policy' do
  | permission, restricted_ready: false|
  context 'permission absent → ' do
    it "denies a user with a different organisation" do
      expect_it.not_to permit(user_context, referential)
    end
  end
  context 'permission present → '  do
    before do
      add_permissions(permission, for_user: user)
    end
    it 'allows a user with a different organisation' do
      expect_it.to permit(user_context, referential)
    end

    if restricted_ready
      it 'removes the permission for archived referentials' do
        referential.update_attribute :ready, true
        expect_it.not_to permit(user_context, referential)
      end
    end
  end
end

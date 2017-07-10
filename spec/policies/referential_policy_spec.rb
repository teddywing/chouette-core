RSpec.describe ReferentialPolicy, type: :policy do

  let( :record ){ build_stubbed :referential }


  #
  # Collection Based Permissions differ from standard as there is no referential yet
  # --------------------------------------------------------------------------------

  permissions :create? do
    it 'permissions present → allowed' do
      add_permissions('referentials.create', for_user: user)
      expect_it.to permit(user_context, record)
    end
    it 'permissions absent → forbidden' do
      expect_it.not_to permit(user_context, record)
    end
  end

  permissions :new? do
    it 'permissions present → allowed' do
      add_permissions('referentials.create', for_user: user)
      expect_it.to permit(user_context, record)
    end
    it 'permissions absent → forbidden' do
      expect_it.not_to permit(user_context, record)
    end
  end

  #
  # Standard Destructive Action Permissions
  # ---------------------------------------

  permissions :destroy? do
    it_behaves_like 'permitted policy and same organisation', 'referentials.destroy', archived: true
  end
  permissions :edit? do
    it_behaves_like 'permitted policy and same organisation', 'referentials.update', archived: true
  end
  permissions :update? do
    it_behaves_like 'permitted policy and same organisation', 'referentials.update', archived: true
  end

  #
  # Custom Permissions
  # ------------------

  permissions :clone? do
    it_behaves_like 'permitted policy and same organisation', 'referentials.create', archived: true
  end

  permissions :archive? do

    context 'permission present →' do
      before do
        add_permissions('referentials.update', for_user: user)
      end

      it 'allowed for unarchived referentials' do
        expect_it.to permit(user_context, record)
      end

      it 'forbidden for archived referentials' do
        record.archived_at = 1.second.ago
        expect_it.not_to permit(user_context, record)
      end
    end

    context 'permission absent →' do 
      it 'is forbidden' do
        expect_it.not_to permit(user_context, record)
      end
    end

  end

  permissions :unarchive? do

    context 'permission present →' do
      before do
        add_permissions('referentials.update', for_user: user)
      end

      it 'forbidden for unarchived referentials' do
        expect_it.not_to permit(user_context, record)
      end

      it 'allowed for archived referentials' do
        record.archived_at = 1.second.ago
        expect_it.to permit(user_context, record)
      end
    end

    context 'permission absent →' do 
      it 'is forbidden' do
        record.archived_at = 1.second.ago
        expect_it.not_to permit(user_context, record)
      end
    end

  end
end

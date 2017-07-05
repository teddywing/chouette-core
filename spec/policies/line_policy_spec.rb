RSpec.describe LinePolicy, type: :policy do

  let( :record ){ build_stubbed :line }
  before { stub_policy_scope(record) }


  #
  #  Non Destructive
  #  ---------------

  context 'Non Destructive actions →' do
    permissions :index? do
      it_behaves_like 'always allowed', 'anything', archived: true
    end
    permissions :show? do
      it_behaves_like 'always allowed', 'anything', archived: true
    end
  end


  #
  #  Destructive
  #  -----------

  context 'Destructive actions →' do
    permissions :create? do
      it_behaves_like 'always forbidden', 'lines.create', archived: true
    end
    permissions :destroy? do
      it_behaves_like 'always forbidden', 'lines.destroy', archived: true
    end
    permissions :edit? do
      it_behaves_like 'always forbidden', 'lines.update', archived: true
    end
    permissions :new? do
      it_behaves_like 'always forbidden', 'lines.create', archived: true
    end
    permissions :update? do
      it_behaves_like 'always forbidden', 'lines.update', archived: true
    end
  end


  #
  #  Custom Footnote Permissions
  #  ---------------------------

  permissions :create_footnote? do
    context 'permission present →' do
      before do
        add_permissions('footnotes.create', for_user: user)
      end

      it 'authorized for unarchived referentials' do
        expect_it.to permit(user_context, record)
      end

      it 'forbidden for archived referentials' do
        referential.archived_at = 1.second.ago
        expect_it.not_to permit(user_context, record)
      end
    end

    context 'permission absent →' do 
      it 'is forbidden' do
        expect_it.not_to permit(user_context, record)
      end
    end
  end

  permissions :destroy_footnote? do
    context 'permission present →' do
      before do
        add_permissions('footnotes.destroy', for_user: user)
      end

      it 'authorized for unarchived referentials' do
        expect_it.to permit(user_context, record)
      end

      it 'forbidden for archived referentials' do
        referential.archived_at = 1.second.ago
        expect_it.not_to permit(user_context, record)
      end
    end

    context 'permission absent →' do 
      it 'is forbidden' do
        expect_it.not_to permit(user_context, record)
      end
    end
  end

  permissions :edit_footnote? do
    context 'permission present →' do
      before do
        add_permissions('footnotes.update', for_user: user)
      end

      it 'authorized for unarchived referentials' do
        expect_it.to permit(user_context, record)
      end

      it 'forbidden for archived referentials' do
        referential.archived_at = 1.second.ago
        expect_it.not_to permit(user_context, record)
      end
    end

    context 'permission absent →' do 
      it 'is forbidden' do
        expect_it.not_to permit(user_context, record)
      end
    end
  end

  permissions :new_footnote? do
    context 'permission present →' do
      before do
        add_permissions('footnotes.create', for_user: user)
      end

      it 'authorized for unarchived referentials' do
        expect_it.to permit(user_context, record)
      end

      it 'forbidden for archived referentials' do
        referential.archived_at = 1.second.ago
        expect_it.not_to permit(user_context, record)
      end
    end

    context 'permission absent →' do 
      it 'is forbidden' do
        expect_it.not_to permit(user_context, record)
      end
    end
  end

  permissions :update_footnote? do
    context 'permission present →' do
      before do
        add_permissions('footnotes.update', for_user: user)
      end

      it 'authorized for unarchived referentials' do
        expect_it.to permit(user_context, record)
      end

      it 'forbidden for archived referentials' do
        referential.archived_at = 1.second.ago
        expect_it.not_to permit(user_context, record)
      end
    end

    context 'permission absent →' do 
      it 'is forbidden' do
        expect_it.not_to permit(user_context, record)
      end
    end
  end

end

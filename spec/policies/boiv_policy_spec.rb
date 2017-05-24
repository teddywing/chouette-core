RSpec.describe BoivPolicy, type: :policy do

  permissions :index? do
    it_behaves_like 'permitted policy and same organisation', 'boiv:read-offer'
  end

  permissions :boiv_read_offer? do
    it_behaves_like 'permitted policy and same organisation', 'boiv:read-offer'
  end

  permissions :show? do
    it_behaves_like 'permitted policy and same organisation', 'boiv:read-offer'
  end

  permissions :boiv? do
    it 'no permission starting with boiv:. →  denies' do
      expect_it.not_to permit(user_context, referential)
    end

    with_user_permission 'boiv:anything' do
      it{ expect_it.to permit(user_context, referential) }
    end
    with_user_permission 'boiv:' do
      it{ expect_it.not_to permit(user_context, referential) }
    end
  end
end

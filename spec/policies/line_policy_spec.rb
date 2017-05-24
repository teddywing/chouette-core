RSpec.describe LinePolicy, type: :policy do

  %w{create destroy edit}.each do | permission |
    footnote_permission = "#{permission}_footnote"
    permissions "#{footnote_permission}?".to_sym do
      it_behaves_like 'permitted policy', "footnotes.#{permission}", restricted_ready: true
    end
  end

  permissions :new_footnote? do
    it_behaves_like 'permitted policy', 'footnotes.create', restricted_ready: true
  end

  permissions :update_footnote? do
    it_behaves_like 'permitted policy', 'footnotes.edit', restricted_ready: true
  end

end

RSpec.describe LinePolicy, type: :policy do

  let( :record ){ build_stubbed :line }


  %w{create destroy edit}.each do | permission |
    footnote_permission = "#{permission}_footnote"
    permissions "#{footnote_permission}?".to_sym do
      it_behaves_like 'permitted policy', "footnotes.#{permission}", archived: true
    end
  end

  permissions :new_footnote? do
    it_behaves_like 'permitted policy', 'footnotes.create', archived: true
  end

  permissions :update_footnote? do
    it_behaves_like 'permitted policy', 'footnotes.edit', archived: true
  end

end

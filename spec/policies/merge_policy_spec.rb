RSpec.describe MergePolicy, type: :policy do

  let( :record ){ build_stubbed :route }

  permissions :create? do
    it_behaves_like 'permitted policy outside referential', 'merges.create'
  end

end

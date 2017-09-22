RSpec.describe ReferentialSuite, type: :model do
  it { should belong_to(:new).class_name('Referential') }
  it { should belong_to(:current).class_name('Referential') }
end

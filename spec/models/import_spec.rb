RSpec.describe Import, :type => :model do

  it { should belong_to(:referential) }
  it { should belong_to(:workbench) }
  it { should belong_to(:parent).class_name(described_class.to_s) }

  it { should enumerize(:status).in("aborted", "canceled", "failed", "new", "pending", "running", "successful") }

  it { should validate_presence_of(:file) }
  it { should validate_presence_of(:referential) }
  it { should validate_presence_of(:workbench) }
end

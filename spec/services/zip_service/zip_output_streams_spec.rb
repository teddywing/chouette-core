RSpec.describe ZipService do
  
  subject{ described_class.new(read_fixture('multiple_references_import.zip')) }

  it "exposes its size" do
    expect( subject.entry_group_streams.size ).to eq(2)
  end
end

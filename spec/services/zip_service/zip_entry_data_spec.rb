RSpec.describe ZipService do

  subject{ described_class.new(read_fixture('multiple_references_import.zip')) }

  it 'can group all entries' do
    expect( subject.entry_groups.keys ).to eq(%w{ref1 ref2})
  end

  context 'creates correct zip data for each subdir' do
    it 'e.g. reference1' do
      reference1_stream = subject.entry_group_streams['ref1']
      control_stream = Zip::InputStream.open( reference1_stream )
      control_entries = described_class.entries(control_stream)
      expect( control_entries.map{ |e| [e.name, e.get_input_stream.read]}.force ).to eq([
        ["multiref/ref1/", ""],
        ["multiref/ref1/datum-1", "multi-ref1-datum1\n"],
        ["multiref/ref1/datum-2", "multi-ref1-datum2\n"]
      ])
    end
    it 'e.g. reference2' do
      reference2_stream = subject.entry_group_streams['ref2']
      control_stream = Zip::InputStream.open( reference2_stream )
      control_entries = described_class.entries(control_stream)
      expect( control_entries.map{ |e| [e.name, e.get_input_stream.read]}.force ).to eq([
        ["multiref/ref2/", ""],
        ["multiref/ref2/datum-1", "multi-ref2-datum1\n"],
        ["multiref/ref2/datum-2", "multi-ref2-datum2\n"]
      ])
    end
  end

end

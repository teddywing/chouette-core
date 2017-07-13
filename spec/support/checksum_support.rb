shared_examples 'checksum support' do |factory_name|
  let(:instance) { create(factory_name) }

  describe '#current_checksum_source' do
    let(:attributes) { ['code_value', 'label_value'] }
    let(:seperator)  { ChecksumSupport::SEPARATOR }
    let(:nil_value)  { ChecksumSupport::VALUE_FOR_NIL_ATTRIBUTE }

    before do
      allow_any_instance_of(instance.class).to receive(:checksum_attributes).and_return(attributes)
    end

    it 'should separate attribute by seperator' do
      expect(instance.current_checksum_source).to eq("code_value#{seperator}label_value")
    end

    context 'nil value' do
      let(:attributes) { ['code_value', nil] }

      it 'should replace nil attributes by default value' do
        source = "code_value#{seperator}#{nil_value}"
        expect(instance.current_checksum_source).to eq(source)
      end
    end

    context 'empty array' do
      let(:attributes) { ['code_value', []] }

      it 'should convert to nil' do
        source = "code_value#{seperator}#{nil_value}"
        expect(instance.current_checksum_source).to eq(source)
      end
    end
  end

  it 'should save checksum on create' do
    expect(instance.checksum).to_not be_nil
  end

  it 'should save checksum_source' do
    expect(instance.checksum_source).to_not be_nil
  end

  it 'should trigger set_current_checksum_source on save' do
    expect(instance).to receive(:set_current_checksum_source)
    instance.save
  end

  it 'should trigger update_checksum on save' do
    expect(instance).to receive(:update_checksum)
    instance.save
  end
end

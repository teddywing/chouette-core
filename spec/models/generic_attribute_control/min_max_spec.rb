RSpec.describe GenericAttributeControl::MinMax, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :default_criticity ){ :warning }

  context 'class attributes' do 
    it 'are correctly set' do
      expect( described_class.default_criticity ).to eq(default_criticity)
      expect( described_class.default_code).to eq(default_code)
    end
    context 'are used in instantiation' do
      let( :record ){ create :min_max }
      let( :default_att_names ){%w[ code origin_code criticity ]}

      it 'all defaults' do
        expect( record.attributes.values_at(*default_att_names ))
          .to eq([ default_code, default_code, 'info' ])
      end
    end
  end

end

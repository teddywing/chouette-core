
H = Support::DataModifier::Hash

# Describing Behavior of ComplianceControl Class Wide Default Attributes (CCCWDA)
RSpec.describe GenericAttributeControl::MinMax, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :default_criticity ){ 'info' }

  context 'class attributes' do
    it 'are correctly set' do
      expect( described_class.default_criticity ).to eq(:warning)
      expect( described_class.default_code).to eq(default_code)
    end
  end
  context 'are used in instantiation' do
    let( :record ){ create :min_max }
    let( :default_att_names ){%w[ code origin_code criticity ]}

    it 'all defaults' do
      expect( record.attributes.values_at(*default_att_names ))
        .to eq([ default_code, default_code, default_criticity])
    end
    it 'but provided values are not overwritten by defaults' do
      # atts = make_random_atts(code: :string, default_code: :string, criticity: %w[warning error])
      code        = random_string
      origin_code = random_string
      criticity   = random_element(%w[warning error])
      # Remove each of the attributes from explicit initialisation to see
      # its value provided by CCCWDA.
      # N.B. enum default (for criticity) takes precedence over the initializer
      #      unless nil is passed in explicitly (untested scenario for now, as
      #      we are suggestuing to remove `criticity` from CCCWDA.

      # atts :: Map(String, (explicit_value, default_value))
      atts = {
        'code'        => [code, default_code],
        'origin_code' => [origin_code, default_code],
        'criticity'   => [criticity, default_criticity]
      }
      atts.keys.each do |key|
        # Replace key to be tested by default value
        expected = H.first_values(atts).merge(key => atts[key].last)
        expected_values = expected.values_at(*default_att_names)
        # Remove key to be tested from atts passed to `#create`
        construction_atts = H.first_values(atts).merge(key => nil).compact
        explicit = create :min_max, construction_atts 

        expect( explicit.attributes.values_at(*default_att_names ))
          .to eq(expected_values)
      end
    end
  end
end

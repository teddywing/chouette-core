RSpec.describe ComplianceControlSetCopyWorker do
  let( :copier ){ ComplianceControlSetCopier }

  let( :compliance_control_set_id ){ double('compliance_control_set_id') }
  let( :referential_id ){ double('referential_id') }
  
  before do
    expect_any_instance_of( copier ).to receive(:copy).with(compliance_control_set_id, referential_id)
  end
  it 'delegates to ComplianceControlSetCopier' do
    described_class.new.perform(compliance_control_set_id, referential_id)
  end
end

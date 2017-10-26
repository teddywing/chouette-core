RSpec.describe ComplianceControlSetCopyWorker do
  it "calls ComplianceControlSetCopier" do
    control_set_id = 55
    referential_id = 99

    expect_any_instance_of(
      ComplianceControlSetCopier
    ).to receive(:copy).with(control_set_id, referential_id)

    ComplianceControlSetCopyWorker.new.perform(control_set_id, referential_id)
  end
end

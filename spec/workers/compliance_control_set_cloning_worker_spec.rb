RSpec.describe ComplianceControlSetCloningWorker do


  it 'is a worker' do
    expect( described_class.new ).to be_a(Sidekiq::Worker)
  end

  it 'delegates perform to the correct lib call' do
    id = double('id')
    organisation_id = double('organisation_id')
    expect_any_instance_of(ComplianceControlSetCloner).to receive(:copy).with(id, organisation_id) 
    described_class.new.perform(id, organisation_id)
  end
  
end

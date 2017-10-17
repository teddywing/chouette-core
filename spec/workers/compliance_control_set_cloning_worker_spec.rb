RSpec.describe ComplianceControlSetCloningWorker do


  it 'is a worker' do
    expect( described_class.new ).to be_a(Sidekiq::Worker)
  end

  it 'delegates perform to the correct lib call' do
    id = random_int
    expect_any_instance_of(ComplianceControlSetCloner).to receive(:copy).with(id) 
    described_class.new.perform(id)
  end
  
end

require 'spec_helper'

RSpec.describe ReferentialCloning, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:referential_cloning)).to be_valid
  end

  it { should belong_to :source_referential }
  it { should belong_to :target_referential }

  describe "ReferentialCloningWorker" do
    let(:referential_cloning) { FactoryGirl.create(:referential_cloning) }

    it "should schedule a job in worker" do
      expect{referential_cloning.run_callbacks(:commit)}.to change {ReferentialCloningWorker.jobs.count}.by(1)
    end
  end
end

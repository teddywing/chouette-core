require 'rails_helper'

RSpec.describe ComplianceCheckSet, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:compliance_check_set)).to be_valid
  end

  it { should belong_to :referential }
  it { should belong_to :workbench }
  it { should belong_to :compliance_control_set }
  it { should belong_to :parent }

  it { should have_many :compliance_checks }
  it { should have_many :compliance_check_blocks }

  describe "#update_status" do
    it "updates :status to successful when all resources are OK" do
      check_set = create(:compliance_check_set)
      create_list(
        :compliance_check_resource,
        2,
        compliance_check_set: check_set,
        status: 'OK'
      )

      check_set.update_status

      expect(check_set.status).to eq('successful')
    end

    it "updates :status to failed when one resource is ERROR" do
      check_set = create(:compliance_check_set)
      create(
        :compliance_check_resource,
        compliance_check_set: check_set,
        status: 'ERROR'
      )
      create(
        :compliance_check_resource,
        compliance_check_set: check_set,
        status: 'OK'
      )

      check_set.update_status
      expect(check_set.reload.status).to eq('failed')
    end

    it "updates :status to warning when one resource is WARNING" do
      check_set = create(:compliance_check_set)
      create(
        :compliance_check_resource,
        compliance_check_set: check_set,
        status: 'WARNING'
      )
      create(
        :compliance_check_resource,
        compliance_check_set: check_set,
        status: 'OK'
      )

      check_set.update_status

      expect(check_set.reload.status).to eq('warning')
    end

    it "updates :status to successful when resources are IGNORED" do
      check_set = create(:compliance_check_set)
      create(
        :compliance_check_resource,
        compliance_check_set: check_set,
        status: 'IGNORED'
      )
      create(
        :compliance_check_resource,
        compliance_check_set: check_set,
        status: 'OK'
      )

      check_set.update_status

      expect(check_set.status).to eq('warning')
    end

  end

  describe 'possibility to delete the associated compliance_control_set' do
    let!(:compliance_check_set) { create :compliance_check_set }

    it do
      expect{ compliance_check_set.compliance_control_set.delete }
        .to change{ ComplianceControlSet.count }.by(-1)
    end
  end
end

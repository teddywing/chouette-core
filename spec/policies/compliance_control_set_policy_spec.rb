require 'rails_helper'

RSpec.describe ComplianceControlSetPolicy do

  let( :record ){ build_stubbed :compliance_control_set }
  before { stub_policy_scope(record) }

  permissions :create? do
    it_behaves_like 'permitted policy outside referential', 'compliance_control_sets.create'
  end

  permissions :update? do
    it_behaves_like 'permitted policy outside referential', 'compliance_control_sets.update'
  end

  permissions :clone? do
    it_behaves_like 'permitted policy outside referential', 'compliance_control_sets.create'
  end

  permissions :destroy? do
    it_behaves_like 'permitted policy outside referential', 'compliance_control_sets.destroy'
  end
end

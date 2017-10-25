require 'rails_helper'

RSpec.describe ComplianceControlPolicy do

  let( :record ){ build_stubbed :compliance_control }
  before { stub_policy_scope(record) }

  permissions :create? do
    it_behaves_like 'permitted policy outside referential', 'compliance_controls.create'
  end

  permissions :update? do
    it_behaves_like 'permitted policy outside referential', 'compliance_controls.update'
  end

  permissions :destroy? do
    it_behaves_like 'permitted policy outside referential', 'compliance_controls.destroy'
  end
end

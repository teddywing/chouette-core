require 'rails_helper'

RSpec.describe ComplianceCheckSetsController, type: :controller do
  login_user

  let(:compliance_check_set) { create :compliance_check_set }

  describe "GET executed" do
    it 'should be successful' do
      get :executed, workbench_id: compliance_check_set.workbench.id, id: compliance_check_set.id
      expect(response).to be_success
    end
  end

  describe "GET index" do
    it 'should be successful' do
      get :index, workbench_id: compliance_check_set.workbench.id, id: compliance_check_set.id
      expect(response).to be_success
    end
  end

end

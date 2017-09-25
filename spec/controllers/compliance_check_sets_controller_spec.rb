require 'rails_helper'

RSpec.describe ComplianceCheckSetsController, type: :controller do
  login_user

  let(:compliance_check_set) { create :compliance_check_set }

  workbench_compliance_check_sets_path(current_offer_workbench)

  describe "GET show" do
    it 'should be successful' do
      get :show, id: compliance_check_set.id
      expect(response).to be_success
    end
  end

  describe "GET index" do
    it 'should be successful' do
      get :index, id: compliance_check_set.id
      expect(response).to be_success
    end
  end

end

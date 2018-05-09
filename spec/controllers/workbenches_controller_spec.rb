require 'spec_helper'

RSpec.describe WorkbenchesController, :type => :controller do
  login_user

  let(:workbench) { create :workbench, organisation: @user.organisation }
  let(:compliance_control_set) { create :compliance_control_set, organisation: @user.organisation }

  describe "GET show" do
    it "returns http success" do
      get :show, id: workbench.id
      expect(response).to have_http_status(302)
    end
  end

  describe 'PATCH update' do
    let(:workbench_params){
      {
        owner_compliance_control_set_ids: {
          import: compliance_control_set.id,
          merge: 2**64/2 - 1
        }
      }
    }
    let(:request){ patch :update, id: workbench.id, workbench: workbench_params }

    it 'should respond with 403' do
      expect(request).to have_http_status 403
    end

    with_permission "workbenches.update" do
      it 'returns HTTP success' do
        expect(request).to redirect_to [workbench]
        p workbench.reload.owner_compliance_control_set_ids
        expect(workbench.reload.compliance_control_set(:import)).to eq compliance_control_set
        # Let's check we support Bigint
        expect(workbench.reload.owner_compliance_control_set_ids["merge"]).to eq (2**64/2 - 1).to_s
      end
    end
  end

end

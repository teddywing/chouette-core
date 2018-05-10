require 'spec_helper'

RSpec.describe WorkbenchesController, :type => :controller do
  login_user

  let(:workbench) { create :workbench, organisation: @user.organisation }
  let(:compliance_control_set) { create :compliance_control_set, organisation: @user.organisation }
  let(:merge_id) { 2**64/2 - 1 } # Let's check we support Bigint

  describe "GET show" do
    it "returns http success" do
      get :show, id: workbench.id
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH update' do
    let(:workbench_params){
      {
        compliance_control_set_ids: {
          after_import: compliance_control_set.id,
          after_merge: merge_id
        }
      }
    }
    let(:request){ patch :update, id: workbench.id, workbench: workbench_params }

    without_permission "workbenches.update" do
      it 'should respond with 403' do
        expect(request).to have_http_status 403
      end
    end

    with_permission "workbenches.update" do
      it 'returns HTTP success' do
        expect(request).to redirect_to [workbench]
        expect(workbench.reload.compliance_control_set(:after_import)).to eq compliance_control_set
        # Let's check we support Bigint
        expect(workbench.reload.owner_compliance_control_set_ids["after_merge"]).to eq merge_id.to_s
      end
    end
  end

end

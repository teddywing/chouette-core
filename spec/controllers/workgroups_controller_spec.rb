RSpec.describe WorkgroupsController, :type => :controller do
  login_user

  let(:workgroup) { create :workgroup }
  let(:workbench) { create :workbench, workgroup: workgroup }
  let(:compliance_control_set) { create :compliance_control_set, organisation: @user.organisation }

  describe 'PATCH update' do
    let(:params){
      {
        id: workgroup.id,
        workgroup: {
          workbenches_attributes: {
            "0" => {
              id: workbench.id,
              owner_compliance_control_set_ids: {
                import: compliance_control_set.id
              }
            }
          }
        }
      }
    }
    let(:request){ patch :update, params }

    it 'should respond with 403' do
      expect(request).to have_http_status 403
    end

    context "when belonging to the owner" do
      before do
        workgroup.update owner: @user.organisation
      end
      it 'returns HTTP success' do
        expect(request).to be_redirect
        expect(workbench.reload.compliance_control_set(:import)).to eq compliance_control_set
      end
    end
  end
end

describe ReferentialsController, :type => :controller do

  login_user

  let(:referential) { Referential.first }
  let(:organisation) { create :organisation }
  let(:other_referential) { create :referential, organisation: organisation }

  describe 'PUT archive' do
    context "user's organisation matches referential's organisation" do
      it 'returns http success' do
        put :archive, id: referential.id
        expect(response).to have_http_status(302)
      end
    end

    context "user's organisation doesn't match referential's organisation" do
      pending "hotfix opens all unknow actions need to close the uneeded later" do
      #it 'raises a ActiveRecord::RecordNotFound' do
        expect { put :archive, id: other_referential.id }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET select_compliance_control_set' do
    it 'gets compliance control set for current organisation' do
      compliance_control_set = create(:compliance_control_set, organisation: @user.organisation)
      create(:compliance_control_set)
      get :select_compliance_control_set, referential_id: referential.id
      expect(assigns[:compliance_control_sets]).to eq([compliance_control_set])
    end
  end

  describe "POST #validate" do
    it "displays a flash message" do
      post :validate, id: referential.id, params: {
        compliance_control_set: create(:compliance_control_set).id
      }

      expect(controller).to set_flash[:notice].to(
        I18n.t('notice.referentials.validate')
      )
    end
  end

  describe "POST #create" do
    context "when duplicating" do
      it "displays a flash message" do
        post :create,
          from: referential.id,
          current_workbench_id: referential.workbench_id,
          referential: {
            name: 'Duplicated'
          }

        expect(controller).to set_flash[:notice].to(
          I18n.t('notice.referentials.duplicate')
        )
      end
    end
  end
end

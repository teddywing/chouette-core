RSpec.describe ExportsController, :type => :controller do
  login_user

  let(:workbench) { create :workbench }
  let(:export)    { create :export, workbench: workbench }

  describe 'GET #new' do
    it 'should be successful if authorized' do
      get :new, workbench_id: workbench.id
      expect(response).to be_success
    end

    it 'should be unsuccessful unless authorized' do
      remove_permissions('exports.create', from_user: @user, save: true)
      get :new, workbench_id: workbench.id
      expect(response).not_to be_success
    end
  end

  describe "POST #create" do
    it "displays a flash message" do
      post :create, workbench_id: workbench.id,
        export: {
          name: 'Offre'
        }

      expect(controller).to set_flash[:notice].to(
        I18n.t('flash.exports.create.notice')
      )
    end
  end
end

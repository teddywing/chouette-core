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
    let(:params){ {name: "foo"} }
    let(:request){ post :create, workbench_id: workbench.id, export: params  }
    it 'should create no objects' do
      expect{request}.to_not change{Export::Base.count}
    end

    context "with full params" do
      let(:params){{
        name: "foo",
        type: "Export::Netex"
      }}

      it 'should be successful' do
        expect{request}.to change{Export::Base.count}.by(1)
      end

      it "displays a flash message" do
        request
        expect(controller).to set_flash[:notice].to(
          I18n.t('flash.exports.create.notice')
        )
      end
    end

    context "with missing options" do
      let(:params){{
        name: "foo",
        type: "Export::Workbench"
      }}

      it 'should be unsuccessful' do
        expect{request}.to change{Export::Base.count}.by(0)
      end
    end

    context "with all options" do
      let(:params){{
        name: "foo",
        type: "Export::Workbench",
        timelapse: 90
      }}

      it 'should be successful' do
        expect{request}.to change{Export::Base.count}.by(1)
      end
    end

    context "with wrong type" do
      let(:params){{
        name: "foo",
        type: "Export::Foo"
      }}

      it 'should be unsuccessful' do
        expect{request}.to raise_error ActiveRecord::SubclassNotFound
      end
    end
  end
end

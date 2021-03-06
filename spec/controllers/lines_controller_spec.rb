RSpec.describe LinesController, :type => :controller do
  login_user

  let(:line_referential) { create :line_referential, member: @user.organisation, objectid_format: :netex }
  let(:line) { create :line, line_referential: line_referential }

  describe 'POST create' do
    let(:line_attrs){{
      name: "test",
      transport_mode: "bus"
    }}
    let(:request){ post :create, line_referential_id: line_referential.id, line: line_attrs }

    with_permission "lines.create" do
      it "should create a new line" do
        expect{request}.to change{ line_referential.lines.count }.by 1
      end

      context "with an empty value in secondary_company_ids" do
        let(:line_attrs){{
          name: "test",
          transport_mode: "bus",
          secondary_company_ids: [""]
        }}

        it "should cleanup secondary_company_ids" do
          expect{request}.to change{ line_referential.lines.count }.by 1
          expect(line_referential.lines.last.secondary_company_ids).to eq []
        end
      end
    end
  end

  describe 'PUT deactivate' do
    let(:request){ put :deactivate, id: line.id, line_referential_id: line_referential.id }

    it 'should respond with 403' do
      expect(request).to have_http_status 403
    end

    with_permission "lines.change_status" do
      it 'returns HTTP success' do
        expect(request).to redirect_to [line_referential, line]
        expect(line.reload).to be_deactivated
      end
    end
  end

  describe 'PUT activate' do
    let(:request){ put :activate, id: line.id, line_referential_id: line_referential.id }
    before(:each){
      line.deactivate!
    }
    it 'should respond with 403' do
      expect(request).to have_http_status 403
    end

    with_permission "lines.change_status" do
      it 'returns HTTP success' do
        expect(request).to redirect_to [line_referential, line]
        expect(line.reload).to be_activated
      end
    end
  end
end
